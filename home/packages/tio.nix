{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ unstable.tio ];
  home.file.".tiorc".source = ./dotfiles/tio/tiorc;
}
