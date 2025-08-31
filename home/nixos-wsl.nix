{ ... }:

{
  imports = [ ./packages/home_base.nix ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
}
