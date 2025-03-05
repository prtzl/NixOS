{ pkgs, config, ... }:

let
  # Create package path
  p = package: (./. + ("/packages/" + "${package}"));
  # Import a package with extra args
  pp = { package, ... } @ args: (
    let
      path = ./. + ("/packages/" + "${package}");
    in
    import "${path}" (
      args // {
        inherit pkgs config;
      }
    )
  );
in
{
  imports = [
    (p "home_basic.nix")
    (p "nvim.nix")
    (p "tmux.nix")
    (p "ranger.nix")
    (p "zsh.nix")
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "24.05";

  # Packages
  home.packages = with pkgs; [
  ];

  home.sessionVariables = {
    NIX_HOME_DERIVATION = "nixos";
  };
}


