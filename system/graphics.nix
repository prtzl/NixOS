{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome.eog
    gnome.gnome-terminal
    gnome.nautilus
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    gnome.gnome-disk-utility
    gnome.gnome-calculator
  ];

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      desktopManager = {
        gnome.enable = true;
      };
      displayManager = {
        gdm.enable = true;
        gdm.wayland = false;
      };
    };
    gnome.core-utilities.enable = false;
  };

}
