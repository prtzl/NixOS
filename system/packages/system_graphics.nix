{ pkgs, ... }:

{
  # Rational is that graphics systems need audo as well, non-graphics do NOT
  imports = [ ./pipewire.nix ];

  environment.systemPackages = with pkgs; [
    # Crytical for Hyprland - currently unstable since it's all a bit new so let's go with latest
    unstable.hyprshade
    unstable.wl-clipboard # clipboard (why is this additional, like  what?)
    unstable.waybar # status bar
    unstable.dunst # notification daemon (unstable is at 1.12 which I need for new features like dynamic size)
    unstable.libnotify # sends notification to notification daemon (dunst)
    unstable.hyprcursor # I guess this has to come separately

    # Helpers (not crytical, but important)
    rofi # app launcher
    hyprshot # screenshot util

    # nice to have GUI apps for a desktop
    eog # image viewer
    evince # pdf viewer
    celluloid # video/music player
    vlc # multimedia in case celluloid sucks
    gnome-calculator # calculatror
    nautilus # file explorer
  ];

  # DE of choice - unstable does not work, it does not boot, I don't know why
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };

  services.displayManager.ly = { enable = true; };

  # Fixes electron apps in wayland, so I've read.
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  # I still don't know  what this is. It ran fine without, but I guess this is better?
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
