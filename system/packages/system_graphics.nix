{ pkgs, ... }:

{
  # Rational is that graphics systems need audo as well, non-graphics do NOT
  imports = [ ./pipewire.nix ];

  environment.systemPackages = with pkgs; [
    # Apps required for desktop environment (Hyprland)
    unstable.hyprshade
    wl-clipboard
    wofi
    unstable.waybar
    unstable.dunst # notification daemon (unstable is at 1.12 which I need for new features like dynamic size)
    libnotify # sends notification to notification daemon (dunst)
    hyprcursor # I guess this has to come separately
    hyprshot
    rose-pine-hyprcursor

    # nice to have GUI apps for a desktop
    eog # image viewer
    evince # pdf viewer
    celluloid # video/music player
    vlc # multimedia in case celluloid sucks
    gnome-calculator # calculatror
    nautilus # file explorer
  ];

  # DE of choice
  programs.hyprland = {
    enable = true;
    package =
      (pkgs.hyprland.override { # or inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        enableXWayland = true; # whether to enable XWayland
        legacyRenderer =
          false; # whether to use the legacy renderer (for old GPUs)
        withSystemd = true; # whether to build with systemd support
      });
  };
  # works anywhere (TUI!), use non-systemd hyprland
  services.displayManager.ly.enable = true;
}
