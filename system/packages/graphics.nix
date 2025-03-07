{ config, pkgs, ... }:

let
  i3Config = pkgs.writeTextFile {
    name = "i3-config";
    text = ''
      ### Basic ###
      # Set mod key to Super (Win key)
      set $mod Mod4
      set $smod Shift
      set $wm_setting_key_left             Left
      set $wm_setting_key_down             Down
      set $wm_setting_key_up               Up
      set $wm_setting_key_right            Right

      set $wm_setting_app_terminal alacritty
      set $wm_setting_app_browser firefox

      ### System ###
      # Open terminal
      bindsym $mod+Return exec $wm_setting_app_terminal

      # Open dmenu
      bindsym $mod+d exec dmenu_run

      # Restart i3
      bindsym $mod+Shift+r restart

      # Lock screen
      bindsym $mod+Shift+l exec i3lock

      # Enable i3status bar
      bar {
          status_command i3status
      }

      ### Apps ###
      bindsym $mod+b exec $wm_setting_app_browser

      ### Workspaces ###
      # Define names for default workspaces for which we configure key bindings later on.
      # We use variables to avoid repeating the names in multiple places.
      set $ws1  "    1    "
      set $ws2  "    2    "
      set $ws3  "    3    "
      set $ws4  "    4    "
      set $ws5  "    5    "
      set $ws6  "    6    "
      set $ws7  "    7    "
      set $ws8  "    8    "
      set $ws9  "    9    "
      set $ws10 "    10    "

      # Switch to workspace n
      bindsym $mod+1 workspace $ws1
      bindsym $mod+2 workspace $ws2
      bindsym $mod+3 workspace $ws3
      bindsym $mod+4 workspace $ws4
      bindsym $mod+5 workspace $ws5
      bindsym $mod+6 workspace $ws6
      bindsym $mod+7 workspace $ws7
      bindsym $mod+8 workspace $ws8
      bindsym $mod+9 workspace $ws9
      bindsym $mod+0 workspace $ws10

      ### Window sizes and positions ###
      # Cange focus
      bindsym $mod+$wm_setting_key_left        focus left
      bindsym $mod+$wm_setting_key_down        focus down
      bindsym $mod+$wm_setting_key_up          focus up
      bindsym $mod+$wm_setting_key_right       focus right

      # Move focused window
      bindsym $mod+$smod+$wm_setting_key_left  move left
      bindsym $mod+$smod+$wm_setting_key_down  move down
      bindsym $mod+$smod+$wm_setting_key_up    move up
      bindsym $mod+$smod+$wm_setting_key_right move right

      ### Utils ###
      # Enter fullscreen mode for the focused window
      bindsym $mod+f fullscreen toggle

      # Toggle between tiling and floating
      bindsym $mod+$smod+f floating toggle

      # Kill the focused window
      bindsym $mod+$smod+q kill

      ### Ending ###

      # Exit i3
      bindsym $mod+Shift+e exec i3-msg exit

      # Start compositor
      exec_always --no-startup-id picom
    '';
  };
in {
  # This gives some basic gui applications: image viewers, players, readers ...
  environment.systemPackages = with pkgs; [
    eog
    evince
    celluloid
    gnome-system-monitor
    gnome-disk-utility
    gnome-calculator
    gnome-screenshot

    i3status
    i3lock
    dmenu
    rofi
    feh
    picom
    volumeicon # for volume control
    lxappearance # for GTK theme management
  ];

  services = {
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      xkb = {
        options = "eurosign:e";
        layout = "us";
      };
      windowManager.i3 = {
        enable = true;
        configFile = "${i3Config}";
      };
      autoRepeatDelay = 200;
      autoRepeatInterval = 20;
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      fira-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };
  };
}
