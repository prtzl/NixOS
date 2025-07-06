{ pkgs, ... }:

{
  imports =
    [ ./alacritty.nix ./dunst.nix ./hyprland.nix ./themes.nix ./waybar.nix ];

  programs = {
    firefox.enable = true;
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    # Browsing
    ungoogled-chromium

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
    # file explorer
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.tumbler
    vlc # multimedia in case celluloid sucks

    # Communication
    signal-desktop
  ];
}
