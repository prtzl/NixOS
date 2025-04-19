{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./hyprland.nix
    ./notifications.nix
    ./themes.nix
    ./waybar.nix
  ];

  programs = {
    firefox.enable = true;
    chromium.enable = true;
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    # Dev
    arduino
    drawio
    jlink
    stm32cubemx

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
