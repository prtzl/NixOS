{ inputs, system, pkgs, lib, home-manager, ... }:

let
  mkSystem = { configuration, hardware ? null }: (lib.nixosSystem {
    inherit system;
    modules = [
      {
        nixpkgs.pkgs = pkgs;
      }
      configuration
    ] ++ (if hardware != null then [ hardware ] else [ ]);
    specialArgs = { inherit inputs; };
  });

  mkHome = { home-derivation, homeArgs ? null }: unwrapHome (home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ home-derivation ];
    extraSpecialArgs = {
      inherit inputs homeArgs;
      lib = import "${home-manager}/modules/lib/stdlib-extended.nix" pkgs.unstable.lib;
    };
  });

  unwrapSystem = nixos-derivation: nixos-derivation.config.system.build.toplevel;
  unwrapHome = home-derivation: home-derivation.activationPackage;
in
{
  inherit mkSystem unwrapSystem mkHome;
}
