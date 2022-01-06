{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
  ];
  
  # Don't let home manager manage itself - by system config
  programs.home-manager.enable = true;
  
  # Mandatory and user stuff
  home.stateVersion = "21.11";
  home.username = "test";
  home.homeDirectory = "/home/test";
  nixpkgs.config.allowUnfree = true;

  # Packages
  home.packages = with pkgs; [ ];

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
}

