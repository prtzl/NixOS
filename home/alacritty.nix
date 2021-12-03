{ lib, ...}:

{
  programs.alacritty = {
    enable = true;
    settings = {
      background_opacity = 1;
      font = {
        #normal.family = "Alacrity Sans";
        size = 11;
        antialias = true;
        autohint = true;
      };
      window = {
        padding = {
          x = 10;
          y = 5;
        };
      };
      colors = {
        primary = {
          background = "0x0d0721";
          foreground = "0xd6d6d6";

          dim_foreground = "0xdbdbdb";
          bright_foreground = "0xd9d9d9";
          dim_background = "0x202020"; # not sure
          bright_background = "0x3a3a3a"; # not sure
        };
        normal = {
          black = "0x1c1c1c";
          red = "0xbc5653";
          green = "0x909d63";
          yellow = "0xebc17a";
          blue = "0x7eaac7";
          magenta = "0xaa6292";
          cyan = "0x86d3ce";
          white = "0xcacaca";
        };
      };
    };
  };
}
