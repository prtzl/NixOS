{ config, pkgs, jlink, ... }:

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
    jlink
    python3

    # Content creation
    audacity
    gimp
    obs-studio

    # Games
    steam
    #minecraft
  ];
}

