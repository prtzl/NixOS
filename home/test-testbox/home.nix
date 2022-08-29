{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
    ../dconf.nix
    ../vscode.nix
    ../alacritty.nix
  ];

  home.username = "test";
  home.homeDirectory ="/home/test";

  # Packages
  home.packages = with pkgs; [
  ];
}

