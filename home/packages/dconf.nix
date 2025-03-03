# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, config, pkgs, notNixos, ... }:

with lib.hm.gvariant;

let
  mkTuple = lib.hm.gvariant.mkTuple;
  mkInt = lib.hm.gvariant.mkUint32;
  backgroundDir = "${config.home.homeDirectory}";
  backgroundPath = "${config.home.homeDirectory}/.background";
  lockscreenPath = "${config.home.homeDirectory}/.lockscreen";
  blackPath = "${config.home.homeDirectory}/.black";
in
{
  home.file.".save-windows.sh".source = ./dotfiles/save.sh;
  home.file.".load-windows.sh".source = ./dotfiles/load.sh;
  home.packages = with pkgs; [ wmctrl zenity xorg.xwininfo papirus-icon-theme mint-themes ];

  dconf.settings = {
    "org/cinnamon" = {
      desklet-snap-interval = 25;
      desktop-effects-workspace = false;
      enable-vfade = false;
      enabled-applets = [ "panel1:left:0:menu@cinnamon.org:0" "panel1:right:1:systray@cinnamon.org:3" "panel1:right:2:xapp-status@cinnamon.org:4" "panel1:center:0:notifications@cinnamon.org:5" "panel1:right:5:printers@cinnamon.org:6" "panel1:right:3:removable-drives@cinnamon.org:7" "panel1:right:4:keyboard@cinnamon.org:8" "panel1:right:6:network@cinnamon.org:10" "panel1:right:9:sound@cinnamon.org:11" "panel1:center:0:calendar@cinnamon.org:13" "panel1:right:0:workspace-switcher@cinnamon.org:14" "panel1:right:8:power@cinnamon.org:15" "panel1:left:1:grouped-window-list@cinnamon.org:15" ];
      enabled-desklets = [ ];
      next-applet-id = 15;
      panel-edit-mode = false;
      panel-zone-symbolic-icon-sizes = "[{\"panelId\": 1, \"left\": 28, \"center\": 28, \"right\": 16}]";
      panels-enabled = [ "1:0:top" ];
      panels-height = [ "1:30" ];
      startup-animation = false;
      workspace-osd-visible = false;
      workspace-expo-view-as-grid = true;
    };

    "org/cinnamon/cinnamon-session" = {
      quit-time-delay = 60;
    };

    "org/cinnamon/desktop/applications/calculator" = {
      exec = "qalculate-gtk";
    };

    "org/cinnamon/desktop/applications/terminal" = {
      exec = "alacritty";
    };

    "org/cinnamon/desktop/background" = {
      picture-options = "scaled";
      picture-uri = "file://${backgroundPath}";
      picture-uri-dark = "file://${backgroundPath}";
    };

    "org/cinnamon/desktop/screensaver" = {
      picture-options = "zoom";
      show-album-art = false;
      floating-widgets = false;
      allow-media-control = false;
      allow-keyboard-shortcuts = false;
      picture-uri = "file://${lockscreenPath}";
      picture-uri-dark = "file://${lockscreenPath}";
    };

    "org/cinnamon/desktop/background/slideshow" = {
      delay = 15;
      image-source = "directory://${backgroundDir}";
    };

    "org/cinnamon/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = true;
      cursor-blink-time = 1200;
      cursor-theme = "Adwaita";
      first-day-of-week = 1;
      gtk-theme = "Mint-Y-Dark-Blue";
      icon-theme = "Papirus-Dark";
      scaling-factor = 0;
    };

    "org/cinnamon/desktop/keybindings" = {
      custom-list = [ "__dummy__" "custom0" "custom1" "custom2" ];
      show-desklets = [ ];
    };

    "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
      binding = [ "<Primary><Alt>t" ];
      command = "alacritty";
      name = "alacritty";
    };

    "org/cinnamon/desktop/keybindings/custom-keybindings/custom1" = {
      binding = [ "<Super>s" ];
      command = "bash ${config.home.homeDirectory}/.save-windows.sh";
      name = "save window states";
    };

    "org/cinnamon/desktop/keybindings/custom-keybindings/custom2" = {
      binding = [ "<Super>r" ];
      command = "bash ${config.home.homeDirectory}/.load-windows.sh";
      name = "restore window states";
    };

    "org/cinnamon/desktop/keybindings/media-keys" = {
      terminal = [ ];
    };

    "org/cinnamon/desktop/keybindings/wm" = {
      maximize = [ "<Super>f" ];
      minimize = [ "<Super>m" ];
      switch-to-workspace-1 = [ "<Alt>1" ];
      switch-to-workspace-2 = [ "<Alt>2" ];
      switch-to-workspace-3 = [ "<Alt>3" ];
      switch-to-workspace-4 = [ "<Alt>4" ];
      switch-to-workspace-5 = [ "<Alt>5" ];
      switch-to-workspace-6 = [ "<Alt>6" ];
      switch-to-workspace-7 = [ "<Alt>7" ];
      switch-to-workspace-8 = [ "<Alt>8" ];
      switch-to-workspace-9 = [ "<Alt>9" ];
      move-to-workspace-1 = [ "<Primary><Alt>1" ];
      move-to-workspace-2 = [ "<Primary><Alt>2" ];
      move-to-workspace-3 = [ "<Primary><Alt>3" ];
      move-to-workspace-4 = [ "<Primary><Alt>4" ];
      move-to-workspace-5 = [ "<Primary><Alt>5" ];
      move-to-workspace-6 = [ "<Primary><Alt>6" ];
      move-to-workspace-7 = [ "<Primary><Alt>7" ];
      move-to-workspace-8 = [ "<Primary><Alt>8" ];
      move-to-workspace-9 = [ "<Primary><Alt>9" ];
    };

    "org/cinnamon/desktop/media-handling" = {
      autorun-never = true;
    };

    "org/cinnamon/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/cinnamon/desktop/sound" = {
      event-sounds = false;
      volume-sound-enabled = false;
    };
    "org/cinnamon/sound" = {
      login-enabled = false;
      logout-enabled = false;
      plug-enabled = false;
      switch-enabled = false;
      tile-enabled = false;
      unplug-enabled = false;
    };
    "org/cinnamon/desktop/wm/preferences" = {
      num-workspaces = 9;
      theme = "Mint-Y";
    };

    "org/cinnamon/launcher" = {
      check-frequency = 300;
      memory-limit = 2048;
    };

    "org/cinnamon/muffin" = {
      desktop-effects = false;
      tile-hud-threshold = 25;
      tile-maximize = true;
      workspace-cycle = false;
      center-new-windows = true;
      draggable-border-width = 10;
    };

    "org/cinnamon/settings-daemon/peripherals/keyboard" =
      if notNixos then
        {
          delay = mkUint32 250;
          repeat-interval = mkUint32 18;
        } else { };

    "org/cinnamon/desktop/peripherals/keyboard" = {
      delay = mkUint32 250;
      numlock-state = "on";
      repeat-interval = mkUint32 18;
    };

    "org/cinnamon/settings-daemon/plugins/power" = {
      sleep-display-ac = 0;
    };

    "org/cinnamon/theme" = {
      name = "Mint-Y-Dark-Blue";
    };

    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 10;
      button-mode = "programming";
      number-format = "automatic";
      refresh-interval = 604800;
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      word-size = 64;
    };

    "org/gnome/desktop/interface" = {
      toolkit-accessibility = false;
      monospace-font-name = "FiraCode Nerd Font Mono 10"; # I want "{monospace-font.family}" + " ${monospace-font.style}";
    };

    "org/gnome/libgnomekbd/keyboard" = {
      layouts = [ "us" "si" ];
      options = [ "grp\tgrp:win_space_toggle" ];
    };

    "org/gnome/nm-applet" = {
      disable-connected-notifications = true;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 154;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 732 289 ];
      window-size = mkTuple [ 1096 822 ];
    };

    "org/nemo/desktop" = {
      computer-icon-visible = false;
      desktop-layout = "false::false";
      home-icon-visible = false;
      show-orphaned-desktop-icons = false;
      volumes-visible = false;
    };

  };
}
