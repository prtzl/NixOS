{ config, pkgs, ... }:

let
  nixos-update = pkgs.writeShellScriptBin "nixos-update" (builtins.readFile ./local-pkgs/nixos-update.sh);
in
{
  # Additional configuration
  imports = [
      ./bootloader.nix 
      ./filesystem.nix
      ./hardware-configuration_basic.nix
      ./udev.nix
      ./pipewire.nix
  ];

  system.stateVersion = "22.05";

  # Cleaning lady
  nix = {
    package = pkgs.unstable.nix;
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    maxJobs = 16;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      binary-caches-parallel-connections = 50
      preallocate-contents = false
      #keep-outputs = true
      #keep-derivations = true
    '';
    trustedUsers = [ "root" "@wheel" ];
  };

  # Packages
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };
  
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
    openssh.enable = true;
    openssh.forwardX11 = true;
    localtime.enable = true;
    geoclue2.enable = true;
    flatpak.enable = true;
  };

  xdg.portal.enable = true; # For flatpak

  # System packages - minimal usable system
  environment = {
    shells = with pkgs; [ bashInteractive zsh ];
    variables = {
      EDITOR = "vim";
      NIX_FLAKE_DIR = "/etc/nixos"; # a symlink to this repo
    };
    systemPackages = with pkgs; [
      nixos-update
      bat
      exa
      ripgrep
      fd
      wget
      nvd
      firefox
      vim
      git
      parted
      unzip
      file
      tio
      tree
      usbutils
      htop
      neofetch
      sl
      lm_sensors
      home-manager
    ];
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    firewall = {
      enable = true;
    };
  };

  users.defaultUserShell = pkgs.zsh;
}

