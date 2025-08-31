{ ... }:

{
  imports = [
    ./packages/home_base.nix
    ./packages/home_graphics.nix
  ];

  home.username = "matej";
  home.homeDirectory = "/home/matej";
}
