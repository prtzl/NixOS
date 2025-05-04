{ pkgs, ... }:

# Hyprland should be installed system-wide so that it's in the boot entries
# home configuration adds all programs and utilities + configuration
# This configuration thus follows whatever is installed with nixos.
# On non-nixos systems the version of hyprland installed in whichever way, has to match.

let
  # Currently pull hyprland resources from unstable - latest
  pkgs-hypr = pkgs.unstable;
  hypershot_shader_toggle = pkgs.writeShellApplication {
    name = "hypershot_shader_toggle";
    runtimeInputs = with pkgs-hypr; [ hyprcursor hyprshade hyprshot ];
    text = builtins.readFile ./dotfiles/hyprshot/hyprshot_shader_toggle.sh;
  };
in {
  home.packages = with pkgs-hypr; [
    # Hyprland configuration
    hyprcursor # I guess this has to come separately
    hyprshade
    wl-clipboard # clipboard (why is this additional, like  what?)
    hyprshot # screenshot util
    networkmanagerapplet # brings network manager applet functionality

    # My stuff
    hypershot_shader_toggle # Custom screenshot utility
  ];

  programs.rofi = {
    enable = true;
    package = pkgs-hypr.rofi-wayland;
    theme = "Arc-Dark";
  };

  # The jummy thing about this is that now as a service it reloads on configurations change automatically!
  wayland.windowManager.hyprland = {
    enable = true;
    # Tricky mamma. Is installed system-wide on nixos
    # so it should match that. If it's not, then ehh.
    package = pkgs.hyprland;
    # Enabled hyprland-session.target which links to graphical-session.target.
    # Using this target for other services waiting for the "gui" to start (for example waybar)
    systemd.enable = true;
    extraConfig = builtins.readFile ./dotfiles/hyprland/hyprland.conf;
  };

  # Start the uwsm hyprland by default on tty1
  # This has to be sourced in "globlal" .profile (shell.nix)
  home.file.".profile.uwsm".text = ''
    if uwsm check may-start && [ "$(tty)" = "/dev/tty1" ]; then
        exec uwsm start hyprland-uwsm.desktop
    fi
  '';

  # Actual hyprland configuration in dotfiles
  home.file.".config/hypr/shaders".source = ./dotfiles/hyprland/shaders;
}
