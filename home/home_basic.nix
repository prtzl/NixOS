{ config, pkgs, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update" (builtins.readFile ./local-pkgs/home-update.sh);
in {
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

