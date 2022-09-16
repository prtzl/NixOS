{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        family = "FiraCode Nerd Font";
        style = "Regular";
        size = 12;
        antialias = true;
        autohint = true;
      };
      window = {
        opacity = 1;
        title = "";
        dynamic_title = true;
        scrolling = {
          history = 1000;
          multiplier = 2;
        };
        padding = {
          x = 5;
          y = 5;
        };
      };
      # ayu_dark
      colors = {
        primary = {
          background = "0x000000";
          foreground = "0xB3B1AD";

          dim_foreground = "0xdbdbdb";
          bright_foreground = "0xd9d9d9";
          dim_background = "0x202020";
          bright_background = "0x3a3a3a";
        };
        normal = {
          black = "0x01060E";
          red = "0xEA6C73";
          green = "0x91B362";
          yellow = "0xF9AF4F";
          blue = "0x53BDFA";
          magenta = "0xFAE994";
          cyan = "0x90E1C6";
          white = "0xC7C7C7";
        };
        bright = {
          black = "0x686868";
          red = "0xF07178";
          green = "0xC2D94C";
          yellow = "0xFFB454";
          blue = "0x59C2FF";
          magenta = "0xFFEE99";
          cyan = "0x95E6CB";
          white = "0xFFFFFF";
        };
      };
    };
  };
}
