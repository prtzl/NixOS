{ config, pkgs, ... }:

{
  # This gives some basic gui applications: image viewers, players, readers ...
  environment.systemPackages = with pkgs; [
    eog
    evince
    celluloid
    gnome-system-monitor
    gnome-disk-utility
    gnome-calculator
    gnome-screenshot
  ];

  # xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  services = {
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      xkb = {
        options = "eurosign:e";
        layout = "us";
      };
      desktopManager = {
        cinnamon.enable = true;
      };
    };
    gnome.core-utilities.enable = false;
    cinnamon.apps.enable = false;
  };
}
