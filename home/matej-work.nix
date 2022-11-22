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

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "22.05";

  # Packages
  home.packages = with pkgs; [
    # Dev
    gcc-arm-embedded
    gcc
    clang-tools
    gnumake
    cmake
    patched.stm32cubemx

    # Media
    gimp
    libreoffice
    unstable.evince

    # Online
    chromium
    patched.megasync
    enpass
    transmission-gtk

    # Communication
    zoom-us
    patched.teams
    skypeforlinux
    patched.signal-desktop

    # Other
    nixgl.nixGLIntel
  ];

  # Non-nixos openGL patched programs
  programs.alacritty.package = pkgs.glWrapIntel {
    pkg = pkgs.alacritty;
  };

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-work";

  };
}

