{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./dconf.nix
    ./alacritty.nix
    ./vscode.nix
  ];
  
  # Don't let home manager manage itself - by system config
  programs.home-manager.enable = true;
  
  # Mandatory and user stuff
  home.stateVersion = "21.11";
  home.username = "matej";
  home.homeDirectory = "/home/matej";
  nixpkgs.config.allowUnfree = true;

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

    # Content creation
    audacity
    gimp
    obs-studio

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
 
    # Games
    steam
    #minecraft
    
    # Extra
    alock
  ];

  # Privat git
  programs.git = {
    enable = true;
    userName  = "prtzl";
    userEmail = "matej.blagsic@protonmail.com";
    extraConfig = {
      core = {
        init.defaultBranch = "master";
      };
      push.default = "current";
    };
  };

  # My eyes
  services.redshift = {
    enable = true;
    temperature.night = 4000;
    temperature.day = 4000;
    latitude = "46.05";
    longitude = "14.5";
  };
}

