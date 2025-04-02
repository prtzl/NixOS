{ pkgs, ... }:

let p = package: ./. + "/packages/${package}";
in {
  imports = [
    (p "home_basic.nix")
    (p "alacritty.nix")
    (p "ranger.nix")
    (p "fonts.nix")
  ];

  home.username = "test";
  home.homeDirectory = "/home/test";
  home.stateVersion = "22.05";

  # Packages
  home.packages = with pkgs; [ ];

  home.sessionVariables = { NIX_HOME_DERIVATION = "test-testbox"; };
}

