{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
    ../neovim.nix
    ../tio.nix
    ../tmux.nix
    ../alacritty.nix
  ];

  home.username = "matej";
  home.homeDirectory ="/home/matej";
  home.stateVersion = "22.05";

  # Packages
  home.packages = with pkgs; [
    nixgl.nixGLIntel
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-work";
  };
}

