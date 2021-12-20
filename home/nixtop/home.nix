{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
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
    stm32cubemx
    stm32flash
    esptool
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

