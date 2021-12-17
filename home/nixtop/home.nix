{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
    ./zsh.nix
  ];
  
  # Mandatory and user stuff
  home.stateVersion = "21.11";
  home.username = "matej";
  home.homeDirectory = "/home/matej";
  nixpkgs.config.allowUnfree = true;

  # Packages
  home.packages = with pkgs; [
    gcc
    gcc-arm-embedded
    gnumake
    cmake
    python3
  ];

  # Privat git
  programs.git = {
    enable = true;
    extraConfig = {
      core = {
        init.defaultBranch = "master";
      };
      push.default = "current";
    };
  };
}
