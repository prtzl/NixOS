{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
    ../vscode.nix
    ../alacritty.nix
  ];

  home.username = "test";
  home.homeDirectory ="/home/test";
  home.stateVersion = "22.05";

  # Packages
  home.packages = with pkgs; [
  ];
}

