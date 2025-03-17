{ config, pkgs, ... }:

{
  imports = [
    ./packages/alacritty.nix
    ./packages/home_basic.nix
    ./packages/i3.nix
    ./packages/redshift.nix
    ./packages/tio.nix
    ./packages/vscode.nix
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "24.11";

  # Packages
  home.packages = with pkgs; [
    # Dev
    stm32cubemx
    drawio

    # Content creation
    gimp

    # Net
    firefox
    chromium

    # Utility
    enpass
    transmission_4-gtk

    # Media
    ffmpeg
    libreoffice

    # Communication
    signal-desktop
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-nixtop";
  };
}
