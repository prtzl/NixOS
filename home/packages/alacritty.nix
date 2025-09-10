{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        size = 12;
      };
      env.TERM = "xterm-256color";
      window = {
        opacity = 1;
        title = "";
        dynamic_title = true;
        padding = {
          x = 8;
          y = 8;
        };
      };
      scrolling = {
        history = 100000;
        multiplier = 2;
      };
      # ayu_dark
      colors = {
        primary = {
          # background = "0x13131C";
          # foreground = "0xB3B1AD";
          foreground = "0xffffff";

          dim_foreground = "0xdbdbdb";
          # bright_foreground = "0xd9d9d9";
          # bright_background = "0x3a3a3a";
          # dim_background = "0x202020";
        };
        normal = {
          black = "0x01060E";
          red = "0xEA6C73";
          green = "0x91B362";
          yellow = "0xF9AF4F";
          blue = "0x53BDFA";
          magenta = "0x9B339B";
          cyan = "0x90E1C6";
          white = "0xC7C7C7";
        };
      };
    };
  };
}
