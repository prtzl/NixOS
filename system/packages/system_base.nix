{ inputs, pkgs, ... }:

{
  system.stateVersion = "25.05";

  # Cleaning lady
  nix = {
    monitored.enable = true;
    monitored.notify = false;
    registry = {
      nixpkgs.flake = inputs.nixpkgs-stable;
      unstable.flake = inputs.nixpkgs-unstable;
      master.to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
      };
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      binary-caches-parallel-connections = 50
      preallocate-contents = false
      #keep-outputs = true
      #keep-derivations = true
    '';
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };
  };

  # Select internationalisation properties
  console.font = "iso02-12x22";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
    };
  };

  systemd.services.systemd-time-wait-sync.wantedBy = [ "multi-user.target" ];
  systemd.additionalUpstreamSystemUnits = [ "systemd-time-wait-sync.service" ];

  services = {
    fwupd.enable = true;
  };

  # Programs

  programs.zsh.enable = true;
  # System packages - minimal usable system
  environment = {
    shells = with pkgs; [
      bashInteractive
      zsh
    ];
    variables = {
      EDITOR = "vim";
      NIX_FLAKE_DIR = "/etc/nixos"; # a symlink to this repo
    };
    systemPackages = with pkgs; [
      fd
      file
      git
      parted
      ripgrep
      tio
      tree
      unstable.nix-index
      unzip
      vim
      wget
    ];
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    enableIPv6 = false;
  };

  users.defaultUserShell = pkgs.zsh;
}
