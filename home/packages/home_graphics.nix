{ pkgs, ... }:

{
  imports =
    [ ./alacritty.nix ./dunst.nix ./hyprland.nix ./themes.nix ./waybar.nix ];

  programs = {
    firefox.enable = true;
    chromium.enable = true;
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    # Dev
    arduino
    drawio

    # Content creation
    audacity
    gimp
    libreoffice

    # Utility
    enpass
    pavucontrol
    transmission_4-gtk

    # Media
    celluloid # video/music player
    eog # image viewer
    evince # pdf viewer
    gnome-calculator # calculatror
    nautilus # file explorer
    vlc # multimedia in case celluloid sucks

    # Communication
    signal-desktop
  ];
}
