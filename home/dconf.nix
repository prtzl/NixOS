# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, pkgs, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
  mkInt = lib.hm.gvariant.mkUint32; 
in
{
  home.packages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.workspace-matrix
    gnomeExtensions.noannoyance-2
    papirus-icon-theme
    matcha-gtk-theme
  ];

  dconf.settings = {

    # Theming
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

    # System configuration
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "trayIconsReloaded@selfmade.pl" "sound-output-device-chooser@kgshank.net" "wsmatrix@martin.zurowietz.de" "noannoyance@daase.net" ];
      disabled-extensions = [];
      favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" ];
      welcome-dialog-last-shown-version = "40.1";
    };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "si" ]) ];
      xkb-options = [ "eurosign:e" "lv3:ralt_switch" ];
    };

    "org/gnome/desktop/interface" = {
      titlebar-font = "Cantarell 11";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkInt 250;
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

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
      idle-dim = false;
      idle-delay = mkInt 180;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = false;
    };

    # Controls
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
      switch-to-workspace-1 = ["<Alt>1"];
      switch-to-workspace-2 = ["<Alt>2"];
      switch-to-workspace-3 = ["<Alt>3"];
      switch-to-workspace-4 = ["<Alt>4"];
      switch-to-workspace-5 = ["<Alt>5"];
      switch-to-workspace-6 = ["<Alt>6"];
      switch-to-workspace-7 = ["<Alt>7"];
      switch-to-workspace-8 = ["<Alt>8"];
      switch-to-workspace-9 = ["<Alt>9"];
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

    # GUI
    "org/gnome/desktop/background" = { picture-uri = ".background"; };
    "org/gnome/desktop/screensaver" = { picture-uri = ".background"; };

    # Applications
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };

    "org/gnome/gnome-system-monitor" = {
      cpu-stacked-area-chart = true;
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
      popup-timeout = 300;
      scale = 0.01;
      show-overview-grid = true;
      show-thumbnails = false;
      show-workspace-names = false;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///session" ];
      uris = [ "qemu:///session" ];
    };
  };
}
