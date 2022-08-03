{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
  ];
  
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
    stlink
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

