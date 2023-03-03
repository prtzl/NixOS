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
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
  home.stateVersion = "22.11";

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
    gimp

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

    # Media
    ffmpeg
    libreoffice
    rhythmbox

    # Communication
    zoom-us
    skypeforlinux
    discord
    signal-desktop
    viber
  ];

  # My eyes
  services.redshift = {
    enable = true;
    temperature.night = 4000;
    temperature.day = 4000;
    latitude = "46.05";
    longitude = "14.5";
  };

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-nixtop";
  };

  dconf.settings = {
    "org/cinnamon/desktop/peripherals/touchpad" = { tap-to-click = true; };
  };
}

