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
    stm32cubemx
    drawio

    # Content creation
    gimp
    obs-studio

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
    signal-desktop-beta
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "matej-nixtop";
  };

  dconf.settings = {
    "org/cinnamon/desktop/peripherals/touchpad" = { tap-to-click = true; };
  };
}

