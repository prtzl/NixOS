{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  outputs = inputs:
    with inputs;
    let
      system = "x86_64-linux";

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = null; }; });

      stableOverlay = self: super: {
          unstable = pkgs-unstable;
          jlink = mkFree jlink-pack-stable.defaultPackage.${system};
      };
      unstableOverlay = self: super: {
          jlink = mkFree jlink-pack-unstable.defaultPackage.${system};
      };
      
      pkgs = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
        overlays = [stableOverlay];
      };
      
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [unstableOverlay];
      };
    in {
      nixosConfigurations = {
        nixbox = inputs.nixpkgs-stable.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.pkgs = pkgs;
            }
            ./system/nixbox/configuration.nix
          ];
        };
        testbox = inputs.nixpkgs-stable.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.pkgs = pkgs;
            }
            ./system/testbox/configuration.nix
          ];
        };
      };
      
      homeConfigurations = {
        matej-nixbox = inputs.home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [
            ./home/matej-nixbox/home.nix
          ];
          extraSpecialArgs = {
            lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs-unstable.lib;
          };
        };
        test-testbox = inputs.home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [
            ./home/test-testbox/home.nix
          ];
          extraSpecialArgs = {
            lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs-unstable.lib;
          };
        };
      };

      nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
      testbox = self.nixosConfigurations.testbox.config.system.build.toplevel;
      matej-nixbox = self.homeConfigurations.matej-nixbox.activationPackage;
      test-testbox = self.homeConfigurations.test-testbox.activationPackage;

      devShells.${system}.default = pkgs.mkShell {
        name = "Installation-shell";
        nativeBuildInputs = with pkgs-unstable; [ nix nixfmt home-manager nvd ];
      };
    };
}
