{ pkgs, ... }:

{
  imports = [ ./packages/home_base.nix ./packages/home_graphics.nix ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";

  home.sessionVariables = { NIX_HOME_DERIVATION = "matej-nixtop"; };
}
