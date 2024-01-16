{ inputs, config, pkgs, ... }:

let
  nixos-update = pkgs.writeShellScriptBin "nixos-update" (builtins.readFile ./local-pkgs/nixos-update.sh);
  nixgen = pkgs.writeShellScriptBin "nixgen" (builtins.readFile ./local-pkgs/nixgen.sh);
in
{
  # Additional configuration
  imports = [
    inputs.nix-monitored.nixosModules.default
    ./bootloader.nix
    ./filesystem.nix
    ./hardware-configuration_basic.nix
    ./udev.nix
    ./pipewire.nix
  ];

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
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      binary-caches-parallel-connections = 50
      preallocate-contents = false
      #keep-outputs = true
      #keep-derivations = true
    '';
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
  };

  systemd.services.systemd-time-wait-sync.wantedBy = [ "multi-user.target" ];
  systemd.additionalUpstreamSystemUnits = [ "systemd-time-wait-sync.service" ];

  # Usefull services
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin pkgs.gutenprint pkgs.gutenprintBin ];
      browsing = true;
    };
    sshd.enable = true;
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
    localtimed.enable = true;
    geoclue2.enable = true;
    flatpak.enable = true;
  };

  # System packages - minimal usable system
  environment = {
    shells = with pkgs; [ bashInteractive zsh ];
    variables = {
      EDITOR = "vim";
      NIX_FLAKE_DIR = "/etc/nixos"; # a symlink to this repo
    };
    systemPackages = with pkgs; [
      fd
      file
      firefox
      git
      home-manager
      htop
      lm_sensors
      neofetch
      unstable.nix-index
      nixgen
      nixos-update
      nvd
      parted
      ripgrep
      unstable.tio
      tree
      unzip
      usbutils
      vim
      wget
    ];
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
    };
  };

  users.defaultUserShell = pkgs.zsh;
}

