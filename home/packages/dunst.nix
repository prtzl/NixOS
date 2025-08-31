{ config, pkgs, ... }:

let
  volume = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = [ config.services.dunst.package ];
    text = builtins.readFile ./dotfiles/dunst/volume.sh;
  };
in
{
  home.packages = with pkgs; [
    volume
    libnotify
  ];
  services.dunst = {
    enable = true;
    configFile = ./dotfiles/dunst/dunstrc;
  };
}
