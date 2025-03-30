{ pkgs, ... }:

{
  imports = [
    ./packages/alacritty.nix
    ./packages/dunst.nix
    ./packages/hyprland.nix
    ./packages/themes.nix
    ./packages/vscode.nix
  ];

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
