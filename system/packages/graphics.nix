{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    eog # image viewer
    evince # pdf viewer
    celluloid # video/music player
    gnome-system-monitor
    gnome-disk-utility
    gnome-calculator
    gnome-screenshot

    i3status # i3 status bar
    i3lock # lock screen
    dmenu # ugly stauts bar search, but works, heh
    rofi # i don't knopw
    feh # either
    picom # compositor
    volumeicon # sounds like volume, but I don't know where it work
    lxappearance # for GTK theme management, I don't know if it works
    unstable.dunst # notification daemon (unstable is at 1.12 which I need for new features like dynamic size)
    libnotify # sends notification to notification daemon (dunst)
  ];

  services = {
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "caps:swapescape"; # swap caps and escape keys - vim yeah
      };
      windowManager.i3.enable = true;
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
