{ config, pkgs, ... }:

let
  nixos-update = pkgs.writeShellScriptBin "nixos-update" (builtins.readFile ./pkgs/nixos-update.sh);
in
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
  ];

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

  # System packages - minimal usable system
  environment = {
    shells = with pkgs; [ bashInteractive zsh ];
    variables = { EDITOR = "vim"; };
    systemPackages = with pkgs; [
      nixos-update
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
    firewall = {
      enable = true;
    };
  };
}

