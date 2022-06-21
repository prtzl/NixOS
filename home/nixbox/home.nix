{ config, pkgs, ... }:

{
  imports = [
    ../home_basic.nix
  ];

  # Packages
  home.packages = with pkgs; [

    # Content creation
    audacity
    gimp
    obs-studio

    # Games
    steam
    #minecraft
  ];
}

