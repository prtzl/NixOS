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
      lib = inputs.nixpkgs-stable.lib;
      home-manager = inputs.home-manager;
      PWD = builtins.getEnv "PWD";

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });
      generators = import ./nix/generators.nix { inherit system lib home-manager pkgs; };
      mkSystem = generators.mkSystem;
      unwrapSystem = generators.unwrapSystem;
      mkHome = generators.mkHome;

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
    rec {
      nixosConfigurations =
        let path = "${PWD}/system";
        in
        rec {
          nixbox = mkSystem { configuration = "${path}/nixbox.nix"; };
          nixtop = mkSystem { configuration = "${path}/nixtop.nix"; hardware = inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s; };
          testbox = mkSystem { configuration = "${path}/testbox.nix"; };
        };

      homeConfigurations =
        let path = "${PWD}/home";
        in
        rec {
          matej-nixbox = mkHome "${path}/matej-nixbox.nix";
          matej-nixtop = mkHome "${path}/matej-nixtop.nix";
          test-testbox = mkHome "${path}/test-testbox.nix";
          matej-work = mkHome "${path}/matej-work.nix";
          matej-ubuntubox = mkHome "${path}/matej-ubuntubox.nix";
        };

      nixbox = unwrapSystem nixosConfigurations.nixbox;
      nixtop = unwrapSystem nixosConfigurations.nixtop;
      testbox = unwrapSystem nixosConfigurations.testbox;
      matej-nixbox = homeConfigurations.matej-nixbox;
      matej-nixtop = homeConfigurations.matej-nixtop;
      test-testbox = homeConfigurations.test-testbox;
      matej-work = homeConfigurations.matej-work;
      matej-ubuntubox = homeConfigurations.matej-ubuntubox;

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
