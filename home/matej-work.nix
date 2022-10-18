{ config, pkgs, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  imports = [
    # ./packages/home_basic.nix
    (p "home_basic.nix")
    (p "nvim.nix")
    (p "tio.nix")
    (p "tmux.nix")
    (p "ranger.nix")
    (p "dconf.nix")
    (p "fonts.nix")
    (p "zsh.nix")
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "22.05";

  # Packages
  home.packages = with pkgs; [
    nixgl.nixGLIntel
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-work";
  };
}

