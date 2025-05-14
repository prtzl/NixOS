{ pkgs, ... }:

{
  imports = [ ./packages/home_base.nix ];

  home.username = "dev";
  home.homeDirectory = "/home/dev";

  # Packages
  home.packages = with pkgs; [ nixgl.nixGLIntel ];

  # Non-nixos openGL patched programs
  programs.alacritty.package = pkgs.glWrapIntel { pkg = pkgs.alacritty; };
}

