{ config, pkgs, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update" (builtins.readFile ./local-pkgs/home-update.sh);
in {
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./tmux.nix
    ./tio.nix
  ];

  home.stateVersion = "22.11";

  # Don't let home manager manage itself - by system config
  programs.home-manager.enable = true;
  
  # Packages
  home.packages = with pkgs; [
    home-update
    roboto
    flac
    zip
    git-crypt
    gnupg
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
}

