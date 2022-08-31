{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome.eog
    gnome.gnome-system-monitor
    gnome.gnome-disk-utility
    gnome.gnome-calculator
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
