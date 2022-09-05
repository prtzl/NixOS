{ config, pkgs, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update" (builtins.readFile ./local-pkgs/home-update.sh);
in {
  programs.home-manager.enable = true;

  # Packages
  home.packages = with pkgs; [
    nvd
    exa
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
    aliases = {
      ci = "commit";
      st = "status";
      co = "checkout";
      di = "diff --color-words";
      br = "branch";
      cob = "checkout -b";
      cm = "!git add -A && git commit -m";
      fc = "!git fetch && git checkout";
      save = "!git add -A && git commit -m 'SAVEPOINT'";
      wip = "commit -am 'WIP'";
    };
  };

  home.file.".background".source = ./wallpaper/tux-my-1440p.png;
  home.file.".lockscreen".source = ./wallpaper/lockscreen.png;
  home.file.".black".source = ./wallpaper/black.png;

  home.sessionVariables = {
    NIX_FLAKE_DIR_HOME = "$HOME/.config/nixpkgs/";
  };
}

