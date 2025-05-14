{ ... }:

{
  imports = [ ./packages/home_base.nix ];

  home.username = "test";
  home.homeDirectory = "/home/test";
}
