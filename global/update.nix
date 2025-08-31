# Install this in home and nixos to get both functions
{
  pkgs,
  lib,
  systemArgs,
  homeArgs,
  ...
}:

let
  updateScript = pkgs.writeShellScript "update.sh" "${builtins.readFile ./dotfiles/update.sh}";
  makeUpdate =
    kind:
    pkgs.writeShellApplication {
      name = "${kind}-update";
      runtimeInputs = [ pkgs.nvd ];
      text = ''
        ${updateScript} ${kind} "$@"
      '';
    };
in
lib.mkMerge [
  (
    if (systemArgs ? isSystem && systemArgs.isSystem) then
      ({
        environment.systemPackages = [ (makeUpdate "nixos") ];
      })
    else
      { }
  )
  (
    if (homeArgs ? isHome && homeArgs.isHome) then
      ({
        home.packages = [ (makeUpdate "home") ];
      })
    else
      { }
  )
]
