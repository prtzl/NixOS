{ inputs, system, pkgs, lib, home-manager, ... }:

let
  mkSystem = { configuration, hardware ? null, modules ? [ ] }:
    let
      systemArgs = { isSystem = true; };
      homeArgs = { };
    in (lib.nixosSystem {
      inherit system;
      modules = [ { nixpkgs.pkgs = pkgs; } configuration ] ++ modules
        ++ (if hardware != null then [ hardware ] else [ ]);
      specialArgs = { inherit inputs systemArgs homeArgs; };
    });

  mkHome = { home-derivation, args ? { }, modules ? [ ] }:
    let
      homeArgs = args // { isHome = true; };
      systemArgs = { };
    in unwrapHome (home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ home-derivation ] ++ modules;
      extraSpecialArgs = {
        inherit inputs homeArgs systemArgs;
        lib = import "${home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib;
      };
    });

  unwrapSystem = nixos-derivation:
    nixos-derivation.config.system.build.toplevel;
  unwrapHome = home-derivation: home-derivation.activationPackage;
in { inherit mkSystem unwrapSystem mkHome; }
