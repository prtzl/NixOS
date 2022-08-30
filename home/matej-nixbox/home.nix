{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
    ../dconf.nix
    ../vscode.nix
    ../alacritty.nix
    ../zsh.nix
    ../neovim.nix
    ../tio.nix
    ../vscode.nix
    ../ranger.nix
  ];

  home.username = "matej";
  home.homeDirectory ="/home/matej";
  home.stateVersion = "22.11";

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

  # My eyes
  services.redshift = {
    enable = true;
    temperature.night = 4000;
    temperature.day = 4000;
    latitude = "46.05";
    longitude = "14.5";
  };
}

