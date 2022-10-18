{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    jlink-pack-stable = {
      url = "github:prtzl/jlink-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    jlink-pack-unstable = {
      url = "github:prtzl/jlink-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs:
    with inputs;
    let
      system = "x86_64-linux";

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });

      stableOverlay = self: super: {
        unstable = pkgs-unstable;
        jlink = mkFree inputs.jlink-pack-stable.defaultPackage.${system};
      };

      unstableOverlay = self: super: {
        jlink = mkFree inputs.jlink-pack-unstable.defaultPackage.${system};
      };

      pkgs = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ stableOverlay inputs.nixgl.overlay ];
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ unstableOverlay ];
      };
    in
    {
      nixosConfigurations =
        let
          mkSystem = hostname: (inputs.nixpkgs-stable.lib.nixosSystem {
            inherit system;
            modules = [
              {
                nixpkgs.pkgs = pkgs;
              }
              ./system/${hostname}/configuration.nix
            ];
          });
        in
        {
          nixbox = mkSystem "nixbox";
          testbox = mkSystem "testbox";
        };

      homeConfigurations =
        let
          mkHome = home-derivation: (inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./home/${home-derivation}
            ];
            extraSpecialArgs = {
              lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs-unstable.lib;
            };
          });
        in
        {
          matej-nixbox = mkHome "matej-nixbox.nix";
          test-testbox = mkHome "test-testbox.nix";
          matej-work = mkHome "matej-work.nix";
          matej-ubuntubox = mkHome "matej-ubuntubox.nix";
        };

      nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
      testbox = self.nixosConfigurations.testbox.config.system.build.toplevel;
      matej-nixbox = self.homeConfigurations.matej-nixbox.activationPackage;
      test-testbox = self.homeConfigurations.test-testbox.activationPackage;
      matej-work = self.homeConfigurations.matej-work.activationPackage;
      matej-ubuntubox = self.homeConfigurations.matej-ubuntubox.activationPackage;

    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Installation-shell";
          nativeBuildInputs = with pkgs-unstable; [ nix nixfmt home-manager nvd ];
        };
      });
}
