{ config, pkgs, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  imports = [
    (p "home_basic.nix")
    (p "nvim.nix")
    (p "tio.nix")
    (p "tmux.nix")
    (p "ranger.nix")
    (p "dconf.nix")
    (p "fonts.nix")
    (p "zsh.nix")
    (p "alacritty.nix")
  ];

  home.username = "mblagsic";
  home.homeDirectory = "/home/mblagsic";
  home.stateVersion = "22.11";

  # Packages
  home.packages = with pkgs; [
    # Dev
    gcc-arm-embedded
    gcc
    clang-tools
    gnumake
    cmake
    stm32cubemx
    jlink
    podman

    # Media
    gimp
    libreoffice
    unstable.evince
    gnome.gnome-screenshot

    # Documents
    texlive.combined.scheme-full
    texstudio

    # Online
    firefox
    chromium
    megasync
    enpass
    transmission-gtk

    # Communication
    skypeforlinux
    unstable.signal-desktop-beta
    unstable.discord

    # Other
    nixgl.nixGLIntel
  ];

  # Non-nixos openGL patched programs
  programs.alacritty.package = pkgs.glWrapIntel {
    pkg = pkgs.alacritty;
  };

  # My eyes
  services.redshift = {
    enable = true;
    temperature.night = 4000;
    temperature.day = 4000;
    latitude = "46.05";
    longitude = "14.5";
  };

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-work";
  };
}

