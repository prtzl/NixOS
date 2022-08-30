{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ ranger ueberzug ];

  home.file.".config/ranger/rc.conf".text = ''
    set show_hidden true
    set preview_images true
    set preview_images_method ueberzug
  '';
}
