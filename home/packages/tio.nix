{ pkgs, ... }:

{
  home.packages = with pkgs; [ tio ];
  home.file.".tiorc".source = ./dotfiles/tio/tiorc;
}
