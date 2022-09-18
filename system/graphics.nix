{ config, pkgs, ... }:

{
  # This gives some basic gui applications: image viewers, players, readers ...
  environment.systemPackages = with pkgs; [
    cinnamon.xreader
    gnome.eog
    celluloid
    gnome.gnome-system-monitor
    gnome.gnome-disk-utility
    gnome.gnome-calculator
    gnome.gnome-screenshot
  ];

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      desktopManager = {
        gnome.enable = false;
        cinnamon.enable = true;
      };
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
        gdm.autoSuspend = false;
      };
    };
    gnome.core-utilities.enable = false;
    cinnamon.apps.enable = false;
  };
}
