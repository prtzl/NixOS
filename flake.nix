{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    jlink-pack.url = "github:prtzl/jlink-nix";
  };

  outputs = inputs:
    with inputs;
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs-stable {
        inherit system;
        config = { allowUnfree = true; };
      };
      
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };

      jlink = jlink-pack.defaultPackage.${system};

      lib = nixpkgs-stable.lib;
    in {
      nixosConfigurations = {
        nixbox = lib.nixosSystem {
          inherit system;
          modules = [
            (let
              overlay-unstable = final: prev: {
                unstable = pkgs-unstable;
            };
            in {
              nixpkgs.overlays = [ overlay-unstable ];
            })
            ./system/nixbox/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.matej = import ./home/nixbox/home.nix;
              home-manager.extraSpecialArgs = { inherit jlink; };
            }
          ];
        };
      };
      
      homeConfigurations = {
        matej-nixbox = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [
            (let
              overlay-unstable = final: prev: {
                unstable = pkgs-unstable;
            };
            in {
              nixpkgs.overlays = [ overlay-unstable ];
            })
            ./home/nixbox/home.nix
          ];
          extraSpecialArgs = { inherit jlink; };
        };
      };

      nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
      matej-nixbox = self.homeConfigurations.matej-nixbox.activationPackage;

      devShell.${system} = pkgs.mkShell {
        name = "Installation-shell";
        nativeBuildInputs = with pkgs-unstable; [ nix nixfmt home-manager nvd ];
      };
    };
}
