{ config, pkgs, ... }:

let p = package: ./. + "/packages/${package}";
in {
  imports = [
    (p "home_basic.nix")
    (p "alacritty.nix")
    (p "tio.nix")
    (p "vscode.nix")
    (p "redshift.nix")
    (p "i3.nix")
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "24.11";

  # Packages
  home.packages = with pkgs; [
    # Dev
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
    firefox
    chromium

    # Latex
    texlive.combined.scheme-full
    texstudio

    # Utility
    enpass
    pavucontrol
    transmission_4-gtk

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
    signal-desktop

    (import (pkgs.fetchFromGitHub {
      owner = "prtzl";
      repo = "proxsign-nix";
      rev = "b54cb7773977efa5831e6aae0a8faab1969421ef";
      sha256 = "sha256-J+QioJsw2MK+3uGDUf+IcAD28tiMxr8Isykb21Ovf5A=";
    }))
  ];

  home.sessionVariables = { NIX_HOME_DERIVATION = "matej-nixbox"; };
}

