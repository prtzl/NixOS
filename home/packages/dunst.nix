{
  config,
  pkgs,
  ...
}:

let
  volume = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = [ config.services.dunst.package ];
    text = builtins.readFile ./dotfiles/dunst/volume.sh;
  };
in
{
  home.packages = with pkgs; [
    volume
    libnotify
  ];
  services.dunst = {
    enable = true;
    # This is broken. Works on rebuild, but the file is cleaned-up after garbage collect
    # And after service restart the file is gone and dunst breaks - goes default
    # configFile = ./dotfiles/dunst/dunstrc;
    settings = {
      global = {
        # General appearance
        font = "FiraCode Nerd Font Mono 18";
        alignment = "center";
        vertical_alignment = "center";
        width = "(0, 450)";
        height = "(0, 100)";
        offset = "(0, 40)";
        separator_height = 2;
        progress_bar_height = 5;
        show_indicators = "no";
        stack_duplicates = "yes";
        frame_width = 5;
        corner_radius = 18;
        max_icon_size = 32;
        min_icon_size = 32;
        sticky_history = false;

        # Colors;
        frame_color = "#2E3440";
        foreground = "#ECEFF4";
        background = "#1A1A1A";
        highlight = "#88C0D0";

        # Icon settings;
        icon_position = "left";
        icon_theme = "Papirus";
        enable_recursive_icon_lookup = true;

        # Format;
        format = "<b>%s (%a)</b>\\n%b";

        # Behavior;
        notification_limit = 5;
        origin = "top-center";
      };

      urgency_low = {
        timeout = 3;
        background = "#4C566A";
        foreground = "#D8DEE9";
      };

      urgency_normal = {
        timeout = 5;
        background = "#3B4252";
        foreground = "#ECEFF4";
      };

      urgency_critical = {
        timeout = 10;
        background = "#BF616A";
        foreground = "#ECEFF4";
        frame_color = "#800020";
      };

      volume = {
        appname = "volume";
        foreground = "#1bc42f";
        frame_color = "#0d5615";
        history_ignore = true;
      };
    };
  };
}
