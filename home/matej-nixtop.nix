{ pkgs, ... }:

{
  imports = [
    ./packages/alacritty.nix
    ./packages/dunst.nix
    ./packages/home_basic.nix
    ./packages/hyprland.nix
    ./packages/themes.nix
    ./packages/tio.nix
    ./packages/vscode.nix
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";

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

  home.sessionVariables = { NIX_HOME_DERIVATION = "matej-nixtop"; };
}
