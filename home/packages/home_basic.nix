{ inputs, config, pkgs, notNixos, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update"
    (builtins.readFile ./dotfiles/home-update.sh);
in {
  nix = if notNixos then {
    # package = inputs.nix-monitored.package.${pkgs.system}.default;
    registry = {
      nixpkgs.flake = inputs.nixpkgs-stable;
      unstable.flake = inputs.nixpkgs-unstable;
      master.to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
      };
    };
  } else
    { };
  programs.home-manager.enable = true;

  # Packages
  home.packages = with pkgs; [
    home-update
    nixfmt-classic
    nvd
    roboto
    flac
    zip
    git-crypt
    gnupg
    bottom
    joplin-desktop
  ];

  # Privat git
  programs.git = {
    enable = true;
    userName = "prtzl";
    userEmail = "matej.blagsic@protonmail.com";
    extraConfig = {
      core = { init.defaultBranch = "master"; };
      push.default = "current";
    };
    aliases = {
      ci = "commit";
      st = "status";
      co = "checkout";
      di = "diff --color-words";
      br = "branch";
      cob = "checkout -b";
      cm = "!git add -A && git commit -m";
      fc = "!git fetch && git checkout";
      save = "!git add -A && git commit -m 'SAVEPOINT'";
      wip = "commit -am 'WIP'";
      sub =
        "submodule update --init --recursive"; # pulls all the submodules at correct commit
    };
  };

  home.file.".background".source = ./wallpaper/tux-nix-1440p.png;
  home.file.".lockscreen".source = ./wallpaper/lockscreen.png;
  home.file.".black".source = ./wallpaper/black.png;

  home.file.".config/dunst/dunstrc".text = ''
    [global]
      origin = top-center
      alignment = center
      notification_limit = 3
      offset = 0x10
      separator_height = 1

    [volume]
      appname = volume
      origin = center
      timeout = 1
      notification_limit = 1
      replace = yes

    [urgency_low]
      timeout = 1

    [urgency_normal]
      timeout = 3

    [urgency_critical]
      timeout = 5
  '';

  home.file.".config/i3/config".text = ''
    ### Basic ###
    # Set mod key to Super (Win key)
    set $mod Mod4
    set $smod Shift
    set $wm_setting_key_left             Left
    set $wm_setting_key_down             Down
    set $wm_setting_key_up               Up
    set $wm_setting_key_right            Right

    set $wm_setting_app_terminal alacritty
    set $wm_setting_app_browser firefox

    ### System ###
    # Open terminal
    bindsym $mod+Return exec $wm_setting_app_terminal

    # Open dmenu
    bindsym $mod+d exec dmenu_run

    # Restart i3
    bindsym $mod+Shift+r restart

    # Lock screen
    bindsym $mod+Shift+l exec i3lock

    # Enable i3status bar
    bar {
        status_command i3status
    }

    ### Apps ###
    bindsym $mod+b exec $wm_setting_app_browser

    ### Workspaces ###
    # Define names for default workspaces for which we configure key bindings later on.
    # We use variables to avoid repeating the names in multiple places.
    set $ws1  "    1    "
    set $ws2  "    2    "
    set $ws3  "    3    "
    set $ws4  "    4    "
    set $ws5  "    5    "
    set $ws6  "    6    "
    set $ws7  "    7    "
    set $ws8  "    8    "
    set $ws9  "    9    "
    set $ws10 "    10    "

    # Switch to workspace n
    bindsym $mod+1 workspace $ws1
    bindsym $mod+2 workspace $ws2
    bindsym $mod+3 workspace $ws3
    bindsym $mod+4 workspace $ws4
    bindsym $mod+5 workspace $ws5
    bindsym $mod+6 workspace $ws6
    bindsym $mod+7 workspace $ws7
    bindsym $mod+8 workspace $ws8
    bindsym $mod+9 workspace $ws9
    bindsym $mod+0 workspace $ws10

    ### Window sizes and positions ###
    # Cange focus
    bindsym $mod+$wm_setting_key_left        focus left
    bindsym $mod+$wm_setting_key_down        focus down
    bindsym $mod+$wm_setting_key_up          focus up
    bindsym $mod+$wm_setting_key_right       focus right

    # Move focused window
    bindsym $mod+$smod+$wm_setting_key_left  move left
    bindsym $mod+$smod+$wm_setting_key_down  move down
    bindsym $mod+$smod+$wm_setting_key_up    move up
    bindsym $mod+$smod+$wm_setting_key_right move right

    ### Utils ###
    # Enter fullscreen mode for the focused window
    bindsym $mod+f fullscreen toggle

    # Toggle between tiling and floating
    bindsym $mod+$smod+f floating toggle

    # Kill the focused window
    bindsym $mod+$smod+q kill

    # Increase volume
    #bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send "Volume Up"
    # Decrease volume
    #bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send "Volume Down"
    # Mute/unmute audio
    #bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send "Mute Toggled"

    bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && dunstify "🔊 Volume Up" -t 1000 -r 6969 -a "volume" -u "low" -h int:value:"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100) "%"}')"
    bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && dunstify "🔉 Volume Down" -t 1000 -r 6969 -a "volume" -u "low" -h int:value:"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100) "%"}')"
    bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && dunstify "🔇 Muted" -t 1000 -r 6969 -a "volume" -u "low" -h int:value:"0"

    ### Ending ###

    # Exit i3
    bindsym $mod+Shift+e exec i3-msg exit

    # Start compositor
    exec_always --no-startup-id picom
  '';

  home.sessionVariables = { NIX_FLAKE_DIR_HOME = "$HOME/.config/nixpkgs/"; };
}

