{ config, pkgs, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update" (builtins.readFile ./pkgs/home-update.sh);
in {
  imports = [
    ./zsh.nix
    ./dconf.nix
    ./alacritty.nix
    ./vscode.nix
    ./neovim.nix
    ./tmux.nix
  ];

  home.username = "matej";
  home.homeDirectory ="/home/matej";
  home.stateVersion = "22.05";

  # Don't let home manager manage itself - by system config
  programs.home-manager.enable = true;
  
  # Packages
  home.packages = with pkgs; [

    home-update

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
    fd

    # Media
    ffmpeg
    libreoffice 

    # Communication
    zoom-us
    teams
    skypeforlinux
    discord

    # Fonts
    roboto
  ];

  # My eyes
  services.redshift = {
    enable = true;
    temperature.night = 4000;
    temperature.day = 4000;
    latitude = "46.05";
    longitude = "14.5";
  };

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

  home.file.".background".source = ./wallpaper/tux-my-1440p.png;
  home.file.".lockscreen".source = ./wallpaper/lockscreen.png;
  home.file.".black".source = ./wallpaper/black.png;

  xdg.configFile."libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
}

