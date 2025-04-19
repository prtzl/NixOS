{ pkgs, ... }:

# Hyprland should be installed system-wide so that it's in the boot entries
# home configuration adds all programs and utilities + configuration
# This configuration thus follows whatever is installed with nixos.
# On non-nixos systems the version of hyprland installed in whichever way, has to match.

let
  # Currently pull hyprland resources from unstable - latest
  pkgs-hyprland = pkgs.unstable;
  hypershot_shader_toggle = pkgs.writeShellApplication {
    name = "hypershot_shader_toggle";
    runtimeInputs = with pkgs-hyprland; [ hyprcursor hyprshade hyprshot ];
    text = builtins.readFile ./dotfiles/hyprshot/hyprshot_shader_toggle.sh;
  };
in {
  home.packages = with pkgs; [
    # Hyprland configuration
    pkgs-hyprland.hyprcursor # I guess this has to come separately
    pkgs-hyprland.hyprshade
    pkgs-hyprland.waybar # status bar
    pkgs-hyprland.wl-clipboard # clipboard (why is this additional, like  what?)
    pkgs-hyprland.hyprshot # screenshot util
    pkgs-hyprland.rofi # app launcher

    # nice to have GUI apps for a desktop
    celluloid # video/music player
    eog # image viewer
    evince # pdf viewer
    gnome-calculator # calculatror
    nautilus # file explorer
    vlc # multimedia in case celluloid sucks

    # My stuff
    hypershot_shader_toggle # Custom screenshot utility
  ];

  # Actual hyprland configuration in dotfiles
  home.file.".config/hypr".source = ./dotfiles/hyprland;
}
