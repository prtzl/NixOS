{ config, pkgs, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  imports = [
    (p "home_basic.nix")
    (p "dconf.nix")
    (p "vscode.nix")
    (p "alacritty.nix")
    (p "zsh.nix")
    (p "nvim.nix")
    (p "tio.nix")
    (p "vscode.nix")
    (p "ranger.nix")
    (p "tmux.nix")
    (p "fonts.nix")
    (p "redshift.nix")
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "23.05";

  # Packages
  home.packages = with pkgs; [
    # Dev
    gcc-arm-embedded
    gcc
    clang-tools
    gnumake
    cmake
    jlink
    stm32cubemx
    arduino
    drawio

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
    pavucontrol
    transmission-gtk

    # Media
    ffmpeg
    libreoffice
    rhythmbox
    tauon
    easytag
    soundconverter
    jamesdsp

    # Communication
    zoom-us
    skypeforlinux
    unstable.discord
    unstable.signal-desktop-beta
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-nixbox";
  };
}

