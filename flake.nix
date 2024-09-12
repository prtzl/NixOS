{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-matej.url = "github:prtzl/nixpkgs/patch";
    nixpkgs-nvim.url = "github:nixos/nixpkgs/91a22f76cd1716f9d0149e8a5c68424bb691de15";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    jlink-pack = {
      url = "github:prtzl/jlink-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs-stable.lib;
      home-manager = inputs.home-manager;
      PWD = builtins.getEnv "PWD";

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });
      generators = import ./nix/generators.nix { inherit inputs system lib home-manager pkgs; };
      inherit (generators) unwrapSystem mkSystem mkHome;

      stableOverlay = self: super: {
        # Packages
        unstable = pkgs-unstable;
        pkgs-nvim = pkgs-nvim;
        patched = pkgs-matej;
        # Stable package overrides/additions
        jlink = mkFree inputs.jlink-pack.defaultPackage.${system};
        glWrapIntel = (import ./nix/nixgl.nix { inherit pkgs; }).glWrapIntel;
        signal-desktop = pkgs-matej.signal-desktop;
        stm32cubemx = pkgs-matej.stm32cubemx;
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

      pkgs-matej = import inputs.nixpkgs-matej {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-nvim = import inputs.nixpkgs-nvim {
        inherit system;
        config.allowUnfree = true;
      };
    in
    rec {
      nixosConfigurations =
        let
          config = file: ./system + "/${file}";
        in
        {
          nixbox = mkSystem { configuration = config "nixbox.nix"; };
          nixtop = mkSystem { configuration = config "nixtop.nix"; hardware = inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s; };
          testbox = mkSystem { configuration = config "testbox.nix"; };
        };

      homeConfigurations =
        let
          config = file: ./home + "/${file}";
        in
        rec {
          matej-nixbox = mkHome { home-derivation = (config "matej-nixbox.nix"); };
          matej-nixtop = mkHome { home-derivation = (config "matej-nixtop.nix"); };
          test-testbox = mkHome { home-derivation = (config "test-testbox.nix"); homeArgs.personal = false; };
          matej-work = mkHome { home-derivation = (config "matej-work.nix"); notNixos = true; };
          matej-ubuntubox = mkHome { home-derivation = (config "matej-ubuntubox.nix"); homeArgs.personal = false; };
          dev-epics = mkHome { home-derivation = (config "dev-epics.nix"); homeArgs.personal = false; };
        };

      nixbox = unwrapSystem nixosConfigurations.nixbox;
      nixtop = unwrapSystem nixosConfigurations.nixtop;
      testbox = unwrapSystem nixosConfigurations.testbox;
      matej-nixbox = homeConfigurations.matej-nixbox;
      matej-nixtop = homeConfigurations.matej-nixtop;
      test-testbox = homeConfigurations.test-testbox;
      matej-work = homeConfigurations.matej-work;
      matej-ubuntubox = homeConfigurations.matej-ubuntubox;
      dev-epics = homeConfigurations.dev-epics;

    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          name = "Installation-shell";
          nativeBuildInputs = with pkgs-unstable; [ nix nixfmt nvd ];
        };
      });
}
