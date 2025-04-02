{ pkgs, config, ... }:

{
  imports = [ ./packages/home_base.nix ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "24.11";

  # Packages
  home.packages = with pkgs; [ ];

  home.sessionVariables = { NIX_HOME_DERIVATION = "nixos-wsl"; };
}

