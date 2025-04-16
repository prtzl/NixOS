{ pkgs, ... }:

let
  home-update = pkgs.writeShellApplication {
    name = "home-update";
    runtimeInputs = with pkgs; [ nvd ];
    text = builtins.readFile ./dotfiles/home-update/home-update.sh;
  };
in { home.packages = [ home-update ]; }
