{ config, pkgs, ... }:

{
  # Additional configuration
  imports = [
      ./bootloader.nix 
      ./filesystem.nix
      ./hardware-configuration_basic.nix
      ./virtualisation.nix
      ./udev.nix
      ./graphics.nix
      ./pipewire.nix
      <home-manager/nixos>
  ];

  # Cleaning lady
  nix = {
    package = pkgs.nixUnstable;
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    maxJobs = 16;
    extraOptions = ''
      binary-caches-parallel-connections = 50
      keep-outputs = true
      keep-derivations = true
    '';
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

  # System packages - minimal usable system
  environment = {
    shells = with pkgs; [ bashInteractive zsh ];
    variables = { EDITOR = "vim"; };
    systemPackages = with pkgs; [
      wget
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
    firewall = {
      enable = true;
    };
  };
}

