{ pkgs, ... }:

{
  imports = [
    ./packages/alacritty.nix
    ./packages/dunst.nix
    ./packages/home_basic.nix
    ./packages/themes.nix
    ./packages/tio.nix
    ./packages/vscode.nix
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
    tauon
    easytag
    soundconverter
    jamesdsp

    # Communication
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

