{ config, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ ranger ueberzug ];

  home.file.".config/ranger/rc.conf".source = ./dotfiles/rc.conf;
}
