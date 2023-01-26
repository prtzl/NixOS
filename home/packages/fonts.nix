{ pkgs, lib, ... }:

let
  mkInt = lib.hm.gvariant.mkUint32;
in
{
  fonts.fontconfig.enable = lib.mkForce true;

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "Cousine" "FiraCode" "RobotoMono" "SourceCodePro" ];
    })
  ];
}
