{
  inputs = {
    # nixpkgs stores
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Utilities by third parties
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # My stuff :)
    # not following "this" nixpkgs allows original package to "lock" a configuration that works
    # Adding one allows this system to use "any" version of nixpkgs, so it kind of "updates" all pacakges but the config.
    jlink-pack.url = "github:prtzl/jlink-nix";
    nvimnix.url = "github:prtzl/nvimnix";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs-stable.lib;
      home-manager = inputs.home-manager;

      mkFree = drv:
        drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });
      generators = import ./nix/generators.nix {
        inherit inputs system lib home-manager pkgs;
      };
      inherit (generators) unwrapSystem mkSystem;
      # Make indirection for home to push in modules just for home (buggy shit)
      mkHome = args@{ ... }:
        generators.mkHome
        ({ modules = [ inputs.nvimnix.nixosModules.default ]; } // args);

      stableOverlay = self: super: {
        # Packages
        unstable = pkgs-unstable;

        # Stable package overrides/additions
        jlink = mkFree inputs.jlink-pack.defaultPackage.${system};
        glWrapIntel = (import ./nix/nixgl.nix { inherit pkgs; }).glWrapIntel;
      };

      pkgs = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ stableOverlay inputs.nixgl.overlay ];
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ];
      };
    in rec {
      nixosConfigurations = {
        nixbox = mkSystem { configuration = ./system/nixbox.nix; };
        nixtop = mkSystem {
          configuration = ./system/nixtop.nix;
          hardware = inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s;
        };
        testbox = mkSystem { configuration = ./system/testbox.nix; };
        wsl = mkSystem { configuration = ./system/wsl.nix; };
      };

      homeConfigurations = {
        matej-nixbox = mkHome {
          home-derivation = ./home/matej-nixbox.nix;
          homeArgs.personal = true;
        };
        matej-nixtop = mkHome {
          home-derivation = ./home/matej-nixtop.nix;
          homeArgs.personal = true;
        };
        test-testbox = mkHome { home-derivation = ./home/test-testbox.nix; };
        matej-work = mkHome {
          home-derivation = ./home/matej-work.nix;
          homeArgs = { notNixos = true; };
        };
        nixos-wsl = mkHome { home-derivation = ./home/nixos-wsl.nix; };
      };

      nixbox = unwrapSystem nixosConfigurations.nixbox;
      nixtop = unwrapSystem nixosConfigurations.nixtop;
      testbox = unwrapSystem nixosConfigurations.testbox;
      wsl = unwrapSystem nixosConfigurations.wsl;

      matej-nixbox = homeConfigurations.matej-nixbox;
      matej-nixtop = homeConfigurations.matej-nixtop;
      test-testbox = homeConfigurations.test-testbox;
      matej-work = homeConfigurations.matej-work;
      nixos-wsl = homeConfigurations.nixos-wsl;

    } // inputs.flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = pkgs.mkShellNoCC {
        name = "Installation-shell";
        nativeBuildInputs = with pkgs-unstable; [ nix nixfmt nvd ];
      };
    });
}
