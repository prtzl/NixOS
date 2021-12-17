{ config, pkgs, ... }:

{
  imports = [
    ./zsh_basic.nix
    ./dconf.nix
    ./alacritty.nix
    ./vscode.nix
    ./neovim.nix
  ];
  
  # Don't let home manager manage itself - by system config
  programs.home-manager.enable = true;
  
  # Packages
  home.packages = with pkgs; [

    # Latex
    texlive.combined.scheme-full
    texstudio

    # Utility
    enpass
    megasync
    flac
    zip
    git-crypt
    gnupg
    pavucontrol
    transmission-gtk
    evince
    celluloid

    # Media
    ffmpeg
    libreoffice 

    # Communication
    mattermost-desktop
    zoom-us
    teams
    skypeforlinux
    discord

    # GNOME
    gnomeExtensions.tray-icons-reloaded
    papirus-icon-theme
    matcha-gtk-theme
 
    # Extra
    alock
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

