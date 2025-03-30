{ pkgs, ... }:

{
  imports = [ ./packages/home_base.nix ./packages/home_graphics.nix ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";

  # Packages
  home.packages = with pkgs; [
    # Content creation
    obs-studio

    # Games
    steam
    # minecraft # broken on NixOS since 1.19 upwards, bummer

    # Media
    easytag
    soundconverter
    jamesdsp

    (import (pkgs.fetchFromGitHub {
      owner = "prtzl";
      repo = "proxsign-nix";
      rev = "b54cb7773977efa5831e6aae0a8faab1969421ef";
      sha256 = "sha256-J+QioJsw2MK+3uGDUf+IcAD28tiMxr8Isykb21Ovf5A=";
    }))
  ];

  home.sessionVariables = { NIX_HOME_DERIVATION = "matej-nixbox"; };
}

