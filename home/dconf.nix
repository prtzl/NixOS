# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
  mkInt = lib.hm.gvariant.mkUint32; 
in
{
  dconf.settings = {

    "org/gnome/desktop/background" = { picture-uri = ".background"; };
    "org/gnome/desktop/screensaver" = { picture-uri = ".background"; };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "si" ]) ];
      xkb-options = [ "eurosign:e" "lv3:ralt_switch" ];
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
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
      show-battery-percentage = true;
    };
   
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkInt 200;
      numlock-state = true;
      repeat-interval = mkInt 18;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
      tap-to-click = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkInt 0;
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

    "org/gnome/gnome-system-monitor" = {
      cpu-stacked-area-chart = true;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = false;
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
      command = "alock -bg image:file=.lockscreen";
      name = "alock";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
      idle-dim = false;
      idle-delay = mkInt 180;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "trayIconsReloaded@selfmade.pl" "sound-output-device-chooser@kgshank.net" "wsmatrix@martin.zurowietz.de"];
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

    "org/gnome/shell/extensions/wsmatrix" = {
      enable-popup-workspace-hover = false;
      multi-monitor = true;
      num-columns = 3;
      num-rows = 3;
      popup-timeout = 400;
      scale = 1.0;
      show-overview-grid = true;
      show-thumbnails = true;
      show-workspace-names = false;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
