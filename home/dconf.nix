# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
    "io/github/celluloid-player/celluloid" = {
      settings-migrated = true;
    };

    "io/github/celluloid-player/celluloid/window-state" = {
      loop-playlist = false;
      maximized = true;
      playlist-width = 250;
      show-playlist = false;
      volume = 1.0;
    };

    "org/gnome/desktop/background" = {
      picture-uri = "/home/matej/NixOS/home/wallpaper/tux-my-1440p.png";
    };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "si" ]) ];
      xkb-options = [ "eurosign:e" "lv3:ralt_switch" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      enable-animations = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Matcha-dark-azul";
      icon-theme = "Papirus-Dark";
      font-name = "Cantarell 11";
      document-font-name = "Cantarell 11";
      monospace-font-name = "Monospace 10";
    };

    "org/gnome/desktop/interface" = {
      titlebar-font = "Cantarell 11";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "org-gnome-nautilus" "megasync"  "enpass" "firefox" "transmission-gtk" "gnome-printers-panel" ];
    };
    
    "org/gnome/desktop/notifications/application/megasync" = {
      application-id = "megasync.desktop";
    };
    "org/gnome/desktop/notifications/application/enpass" = {
      application-id = "enpass.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-printers-panel" = {
      application-id = "gnome-printers-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/transmission-gtk" = {
      application-id = "transmission-gtk.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 200;
      numlock-state = true;
      repeat-interval = lib.hm.gvariant.mkUint32 18;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
      tap-to-click = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>f" ];
      minimize = [ "<Super>m" ];
      move-to-workspace-left = [ "<Primary><Shift><Alt>Left" ];
      move-to-workspace-right = [ "<Primary><Shift><Alt>Right" ];
      show-desktop = [ "<Super>d" ];
      switch-applications = [];
      switch-applications-backward = [];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/eog/view" = {
      background-color = "rgb(0,0,0)";
      use-background-color = true;
    };

    "org/gnome/evince/default" = {
      window-ratio = mkTuple [ 1.0079358146473232 0.7126821793821045 ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/gnome-system-monitor" = {
      cpu-stacked-area-chart = true;
      current-tab = "resources";
      maximized = true;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 1920 1080 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = false;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      maximized = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
      screensaver = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "alacritty";
      name = "terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>l";
      command = "alock";
      name = "alock";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "trayIconsReloaded@selfmade.pl" "sound-output-device-chooser@kgshank.net"];
      disabled-extensions = [ "audio-output-switcher@anduchs" ];
      favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" ];
      welcome-dialog-last-shown-version = "40.1";
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-padding-horizontal = 10;
      icons-limit = 8;
      tray-margin-left = 4;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Matcha-dark-azul";
    };

    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 161;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 2919 262 ];
      window-size = mkTuple [ 1203 902 ];
    };

    "org/virt-manager/virt-manager" = {
      manager-window-height = 550;
      manager-window-width = 550;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = false;
      network-traffic = false;
    };

  };
}
