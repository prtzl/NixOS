{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jlink-pack.url = "github:prtzl/jlink-nix";
  };

  outputs = inputs:
    with inputs;
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
      
      lib = nixpkgs.lib;
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
            nixpkgs.nixosModules.notDetected
            ./system/nixbox/configuration.nix
          ];
        };
        
        nixtop = lib.nixosSystem {
          inherit system;
          modules = [
            (let
              overlay-unstable = final: prev: {
                unstable = pkgs-unstable;
            };
            in {
              nixpkgs.overlays = [ overlay-unstable ];
            })
            nixpkgs.nixosModules.notDetected
            ./system/nixtop/configuration.nix
          ];
        };
      };
      
      homeConfigurations = {
        matej-nixbox = home-manager.lib.homeManagerConfiguration rec {
          inherit system pkgs;
          username = "matej";
          homeDirectory = "/home/${username}";
          stateVersion = "22.05";
          configuration = {
            nixpkgs = {
              config = {
                allowUnfree = true;
                allowBroken = false;
              };
            };
            imports = [
              (let
                overlay-unstable = final: prev: {
                  unstable = pkgs-unstable;
              };
              in {
                nixpkgs.overlays = [ overlay-unstable ];
              })
              ./home/nixbox/home.nix
            ];
          };
        };
      };

      nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
      matej-nixbox = self.homeConfigurations.matej-nixbox.activationPackage;

      devShell.${system} = pkgs.mkShell {
        name = "Installation-shell";
        nativeBuildInputs = with pkgs-unstable; [ nix nixfmt home-manager ];
      };
    };
}
