{ conf, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    environment = {
      "TERM" = "xterm-256color";
    };
    settings = {
      font_size = "14.0";
      disable_ligatures = "cursor";
      mouse_hide_wait = "2.0";
      cursor_blink_interval = "0";
      remember_window_size = "no";
      initial_window_width = "960";
      initial_window_height = "640";
      confirm_os_window_close = "0";

      # Font
      font_family = "FiraCode Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Color scheme
      active_border_color = "#00ff00";
      background = "#000000";
      foreground = "#B3B1AD";
      color0 = "#01060E";
      color8 = "#686868";
      color1 = "#EA6C73";
      color9 = "#F07178";
      color2 = "#91B362";
      color10 = "#C2D94C";
      color3 = "#F9AF4F";
      color11 = "#FFB454";
      color4 = "#53BDFA";
      color12 = "#59C2FF";
      color5 = "#FAE994";
      color13 = "#FFEE99";
      color6 = "#90E1C6";
      color14 = "#95E6Cb";
      color7 = "#C7C7C7";
      color15 = "#FFFFFF";
    };
  };
}
