{ config, pkgs, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  imports = [
    (p "home_basic.nix")
    (p "nvim.nix")
    (p "tmux.nix")
    (p "fonts.nix")
    (p "zsh.nix")
    (p "alacritty.nix")
  ];

  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "22.11";

  # Packages
  home.packages = with pkgs; [
    nixgl.nixGLIntel
  ];

  # Non-nixos openGL patched programs
  programs.alacritty.package = pkgs.glWrapIntel {
    pkg = pkgs.alacritty;
  };

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "dev-epics";
  };
}

