{ pkgs, lib, ... }:

let
  mkInt = lib.hm.gvariant.mkUint32;
in
{
  fonts.fontconfig.enable = lib.mkForce true;

  home.packages = with pkgs; [
    # don't install all fonts - takes time
    (nerdfonts.override {
      fonts = [ "FiraCode" ];
    })
  ];
}
