{ pkgs, system, ... }:

{
  environment.systemPackages = with pkgs; [
    # Apps required for desktop environment (Hyprland)
    hyprshade
    wl-clipboard
    wofi
    waybar
    unstable.dunst # notification daemon (unstable is at 1.12 which I need for new features like dynamic size)
    libnotify # sends notification to notification daemon (dunst)
    hyprcursor # I guess this has to come separately
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
  services.displayManager.ly.enable =
    true; # works anywhere (TUI!), use non-systemd hyprland

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      fira-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };
  };
}
