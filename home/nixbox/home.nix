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

