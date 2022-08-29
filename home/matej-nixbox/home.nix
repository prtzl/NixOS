{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
    ../dconf.nix
    ../vscode.nix
    ../alacritty.nix
  ];

  home.username = "matej";
  home.homeDirectory ="/home/matej";

  # Packages
  home.packages = with pkgs; [
    # Dev
    jetbrains.clion
    jetbrains.pycharm-community
    gcc-arm-embedded
    gcc
    clang-tools
    gnumake
    cmake
    unstable.jlink
    unstable.stm32cubemx

    # Content creation
    audacity
    gimp
    obs-studio

    # Games
    steam
    minecraft

    # Net
    chromium

    # Latex
    texlive.combined.scheme-full
    texstudio

    # Utility
    enpass
    megasync
    pavucontrol
    transmission-gtk
    evince
    celluloid

    # Media
    ffmpeg
    libreoffice 

    # Communication
    zoom-us
    teams
    skypeforlinux
    discord
  ];
}

