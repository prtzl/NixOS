{ system, pkgs, lib, home-manager, ... }:

let
  mkSystem = { configuration, hardware ? false }: (lib.nixosSystem {
    inherit system;
    modules = [
      {
        nixpkgs.pkgs = pkgs;
      }
      "${configuration}"
    ] ++ (if hardware != null then [ hardware ] else [ ]);
  });

  mkHome = home-derivation: (home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ "${home-derivation}" ];
    extraSpecialArgs = {
      lib = import "${home-manager}/modules/lib/stdlib-extended.nix" pkgs.unstable.lib;
    };
  });
in
{
  inherit mkSystem mkHome;
}
