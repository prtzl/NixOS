{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    package = pkgs.unstable.tmux;
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/tmux.conf;
  };
}
