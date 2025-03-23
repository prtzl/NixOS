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

    i3status
    i3lock
    dmenu
    rofi
    feh
    picom
    volumeicon # for volume control
    lxappearance # for GTK theme management
    unstable.dunst # notification daemon
    libnotify # sends notification to notification daemon (dunst)
  ];

  services = {
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      xkb = { layout = "us"; };
      windowManager.i3 = { enable = true; };
      autoRepeatDelay = 180;
      autoRepeatInterval = 15;
      deviceSection = ''
        Option "TearFree" "on"
      '';
    };
  };

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
