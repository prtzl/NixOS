{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
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
        matej-nixbox = home-manager.lib.homeManagerConfiguration {
          inherit system;
          homeDirectory = "/home/matej";
          username = "matej";
          stateVersion = "21.11";
          configuration = 
            let
              overlay-unstable = final: prev: {
                unstable = nixpkgs-unstable.legacyPackages.${system};
              };
            in {
              nixpkgs = {
                overlays = [ overlay-unstable ];
                config = {
                  allowUnfree = true;
                  allowBroken = false;
                };
              };    
              imports = [ ./home/nixbox/home.nix ];
            };
        };
      };

      devShell.${system} =
        pkgs.mkShell { nativeBuildInputs = with pkgs-unstable; [ nix nixfmt ]; };
    };
}
