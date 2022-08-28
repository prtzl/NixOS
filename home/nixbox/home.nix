{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
  ];

  # Packages
  home.packages = with pkgs; [

    # Dev
    jetbrains.clion
    jetbrains.pycharm-community
    gcc-arm-embedded
    gcc
    clang-tools
    gnumake
    cmake
    unstable.jlink
    unstable.stm32cubemx

    # Content creation
    audacity
    gimp
    obs-studio

    # Games
    steam
    #minecraft
  ];
}

