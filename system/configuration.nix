{ config, pkgs, ... }:

{
  # Additional configuration
  imports = [
      ./bootloader.nix 
      ./filesystem.nix
      ./hardware-configuration.nix
      ./virtualisation.nix
      ./udev.nix
      ./graphics.nix
      ./pipewire.nix
  ];

  # Cleaning lady
  nix = {
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

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixbox";
    #networkmanager.enable = true;
    #useNetworkd = true;
    useDHCP = false;
    interfaces.enp9s0.useDHCP = true;
  };
  
  # Set your time zone - where are you ?
  location.provider = "geoclue2";
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = { font = "Lat2-Terminus16"; };

  # Usefull services
  services = {
    printing.enable = true;
    printing.drivers = [ pkgs.hplip ];
    openssh.enable = true;
    localtime.enable = true;
    geoclue2.enable = true;
  };

  # User sh$t
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      matej = {
        isNormalUser = true;
	    isSystemUser = false;
        createHome = true;
        extraGroups = [ "wheel" "libvirtd" "dialout" "audio" "video" "usb" "podman" ];
      };
    };
  };

  # System packages - minimal usable system
  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.variables = { EDITOR = "vim"; };
  environment.systemPackages = with pkgs; [
    wget
    firefox
    vim
    git
    parted
    home-manager
    unzip
    file
    tio
    tree
    usbutils
    htop
    neofetch
    sl
    lm_sensors
  ];

  networking.firewall.enable = true;

  system.stateVersion = "21.05";
}

