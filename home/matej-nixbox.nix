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
  home.stateVersion = "24.05";

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
    # minecraft # broken on NixOS since 1.19 upwards, bummer

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

    (import (pkgs.fetchFromGitHub {
      owner = "prtzl";
      repo = "proxsign-nix";
      rev = "b54cb7773977efa5831e6aae0a8faab1969421ef";
      sha256 = "sha256-J+QioJsw2MK+3uGDUf+IcAD28tiMxr8Isykb21Ovf5A=";
    }))
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-nixbox";
  };
}

