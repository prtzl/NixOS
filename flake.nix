{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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
    nixpkgs-matej = {
      url = "github:prtzl/nixpkgs/master";
    };
    nixpkgs-nvim = {
      url = "github:nixos/nixpkgs/f994293d1eb8812f032e8919e10a594567cf6ef7";
    };
  };

  outputs = inputs:
    with inputs;
    let
      system = "x86_64-linux";

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });

      stableOverlay = self: super: {
        # Packages
        unstable = pkgs-unstable;
        pkgs-nvim = pkgs-nvim;
        patched = pkgs-matej;
        # Stable package overrides/additions
        jlink = mkFree inputs.jlink-pack-stable.defaultPackage.${system};
        glWrapIntel = (import ./nix/nixgl.nix { inherit pkgs; }).glWrapIntel;
        signal-desktop = pkgs-matej.signal-desktop;
        stm32cubemx = pkgs-matej.stm32cubemx;
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

      pkgs-matej = import inputs.nixpkgs-matej {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-nvim = import inputs.nixpkgs-nvim {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations =
        let
          mkSystem = { configuration, hardware ? false }: (inputs.nixpkgs-stable.lib.nixosSystem {
            inherit system;
            modules = [
              {
                nixpkgs.pkgs = pkgs;
              }
              ./system/${configuration}
            ] ++ (if hardware != null then [ hardware ] else [ ]);
          });
        in
        {
          nixbox = mkSystem { configuration = "nixbox.nix"; };
          nixtop = mkSystem { configuration = "nixtop.nix"; hardware = inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s; };
          testbox = mkSystem { configuration = "testbox.nix"; };
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
          matej-nixtop = mkHome "matej-nixtop.nix";
          test-testbox = mkHome "test-testbox.nix";
          matej-work = mkHome "matej-work.nix";
          matej-ubuntubox = mkHome "matej-ubuntubox.nix";
        };

      nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
      nixtop = self.nixosConfigurations.nixtop.config.system.build.toplevel;
      testbox = self.nixosConfigurations.testbox.config.system.build.toplevel;
      matej-nixbox = self.homeConfigurations.matej-nixbox.activationPackage;
      matej-nixtop = self.homeConfigurations.matej-nixtop.activationPackage;
      test-testbox = self.homeConfigurations.test-testbox.activationPackage;
      matej-work = self.homeConfigurations.matej-work.activationPackage;
      matej-ubuntubox = self.homeConfigurations.matej-ubuntubox.activationPackage;

    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Installation-shell";
          nativeBuildInputs = with pkgs-unstable; [ nix nixfmt nvd ];
        };
      });
}
