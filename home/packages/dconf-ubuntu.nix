# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "si" ]) ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
      font-hinting = "slight";
      gtk-theme = "Yaru-blue-dark";
      icon-theme = "Yaru-blue";
      toolkit-accessibility = false;
      monospace-font-name = "FiraCode Nerd Font 13";
    };

    "org/gnome/desktop/notifications" = {
      show-banners = true;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 250;
      repeat-interval = mkUint32 18;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
    };

    "org/gnome/desktop/screensaver" = {
      lock-delay = mkUint32 0;
      lock-enabled = false;
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 9;
    };

    "org/gnome/gedit/preferences/editor" = {
      scheme = "Yaru-dark";
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 3600;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      favorite-apps = [ "firefox_firefox.desktop" "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      isolate-monitors = false;
      isolate-workspaces = true;
      show-trash = false;
    };

    "org/gnome/shell/extensions/ding" = {
      show-home = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
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
    };

  };
}
