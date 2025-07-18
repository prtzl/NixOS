{ inputs, pkgs, homeArgs, ... }:

{
  nix = if (homeArgs ? notNixos && homeArgs.notNixos) then {
    # package = inputs.nix-monitored.package.${pkgs.system}.default;
    registry = {
      nixpkgs.flake = inputs.nixpkgs-stable;
      unstable.flake = inputs.nixpkgs-unstable;
      master.to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
      };
    };
  } else
    { };

  imports =
    [ ./nvim.nix ./ranger.nix ./shell.nix ./tio.nix ./tmux.nix ./zsh.nix ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Util
    bottom
    git-crypt
    git-lfs
    gnupg
    nixfmt-classic
    nvd
    zip

    # Media
    ffmpeg
  ];

  # Privat git
  programs.git = (if (homeArgs ? personal && homeArgs.personal) then {
    userName = "prtzl";
    userEmail = "matej.blagsic@protonmail.com";
  } else
    { }) // {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        core = { init.defaultBranch = "master"; };
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
        sub =
          "submodule update --init --recursive"; # pulls all the submodules at correct commit
      };
    };

  home.file.".background".source = ./wallpaper/tux-nix-1440p.png;
  home.file.".lockscreen".source = ./wallpaper/lockscreen.png;
  home.file.".black".source = ./wallpaper/black.png;

  home.sessionVariables = { NIX_FLAKE_DIR_HOME = "$HOME/.config/nixpkgs/"; };
}

