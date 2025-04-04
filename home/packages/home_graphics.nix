{ pkgs, ... }:

{
  imports =
    [ ./alacritty.nix ./dunst.nix ./hyprland.nix ./themes.nix ./waybar.nix ];

  programs.vscode.enable = true;

  home.packages = with pkgs; [
    # Dev
    arduino
    drawio
    jlink
    stm32cubemx

    # Net
    chromium
    firefox

    # Content creation
    audacity
    gimp

    # Latex
    texstudio

    # Utility
    enpass
    pavucontrol
    transmission_4-gtk

    # Media
    tauon

    # Communication
    signal-desktop
  ];
}
