{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
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
    nixpkgs-matej = {
      url = "github:prtzl/nixpkgs/patch";
    };
  };

  outputs = inputs:
    with inputs;
    let
      system = "x86_64-linux";

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });

      glWrapIntel = { pkg, deps ? [ ] }: pkgs.stdenv.mkDerivation rec {
        pname = pkg.pname + "-glwrap";
        version = pkg.version;
        src = pkg;
        nativeBuildInputs = [ pkg pkgs.nixgl.nixGLIntel ] ++ deps;
        installPhase = ''
          mkdir -p $out/bin
          for d in `find $src -maxdepth 1 -type d ! -path $src | grep -v bin`; do
            ln -s $d $out/$(basename $d)
          done
          for fpath in `find $src/bin -type f`; do
            f=$(basename $fpath)
            fold=$f"_base"
            ln -s $fpath $out/bin/$fold
            touch $out/bin/$f
            chmod +x $out/bin/$f
            echo "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/$fold" > $out/bin/$f
          done
        '';
      };

      stableOverlay = self: super: {
        unstable = pkgs-unstable;
        jlink = mkFree inputs.jlink-pack-stable.defaultPackage.${system};
        patched = pkgs-matej;
        glWrapIntel = glWrapIntel;
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
    in
    {
      nixosConfigurations =
        let
          mkSystem = { configuration, hardware ? null }: (inputs.nixpkgs-stable.lib.nixosSystem {
            inherit system;
            modules = [
              {
                nixpkgs.pkgs = pkgs;
              }
              ./system/${configuration}
            ] ++ (if hardware ? null then hardware else []);
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

    } // inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
        in
        {
          devShells.default = pkgs.mkShell {
            name = "Installation-shell";
            nativeBuildInputs = with pkgs-unstable; [ nix nixfmt home-manager nvd ];
          };
        });
}
