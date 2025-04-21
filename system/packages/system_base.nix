{ inputs, pkgs, ... }:

let
  nixos-update = pkgs.writeShellScriptBin "nixos-update"
    (builtins.readFile ./local-pkgs/nixos-update.sh);
  nixgen = pkgs.writeShellScriptBin "nixgen"
    (builtins.readFile ./local-pkgs/nixgen.sh);
in {
  system.stateVersion = "24.11";

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
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
  };

  # Select internationalisation properties
  console.font = "iso02-12x22";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_TIME = "en_DK.UTF-8"; };
  };

  systemd.services.systemd-time-wait-sync.wantedBy = [ "multi-user.target" ];
  systemd.additionalUpstreamSystemUnits = [ "systemd-time-wait-sync.service" ];

  services = { fwupd.enable = true; };

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
      git
      home-manager
      htop
      lm_sensors
      nixgen
      nixos-update
      nvd
      parted
      pciutils
      ripgrep
      tio
      tree
      unstable.nix-index
      unzip
      usbutils
      vim
      wget
    ];
  };

  programs.wireshark.enable = true;
  programs.zsh.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    enableIPv6 = false;
  };

  users.defaultUserShell = pkgs.zsh;
}
