{ inputs, config, pkgs, notNixos, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update"
    (builtins.readFile ./dotfiles/home-update.sh);
in {
  nix = if notNixos then {
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

  imports = [ ./fonts.nix ./nvim.nix ./ranger.nix ./tmux.nix ./zsh.nix ];

  programs.home-manager.enable = true;

  # Packages
  home.packages = with pkgs; [
    home-update
    nixfmt-classic
    nvd
    roboto
    zip
    git-crypt
    gnupg
    bottom
    git
  ];

  # Privat git
  programs.git = {
    enable = true;
    userName = "prtzl";
    userEmail = "matej.blagsic@protonmail.com";
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

