{ config, pkgs, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  imports = [
    (p "home_basic.nix")
    (p "nvim.nix")
    (p "tio.nix")
    (p "tmux.nix")
    (p "ranger.nix")
    (p "dconf.nix")
    (p "fonts.nix")
    (p "zsh.nix")
    (p "alacritty.nix")
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "22.05";

  # Packages
  home.packages = with pkgs; [
    nixgl.nixGLIntel
    patched.signal-desktop
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-work";

  };
}

