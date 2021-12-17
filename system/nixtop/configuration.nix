{ config, pkgs, ... }:

{
  # Additional configuration
  imports = [
      ../configuration_basic.nix
      ./hardware-configuration.nix
  ];

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixtop";
    #networkmanager.enable = true;
    #useNetworkd = true;
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
   };
  
  # Set your time zone - where are you ?
  location.provider = "geoclue2";
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = { font = "Lat2-Terminus16"; };

# User sh$t
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      matej = {
        isNormalUser = true;
	    isSystemUser = false;
        createHome = true;
        extraGroups = [ "wheel" "libvirtd" "dialout" "audio" "video" "usb" "podman" "docker" ];
      };
    };
  };
  home-manager.users.matej = import ../../home/nixtop/home.nix;

  system.stateVersion = "21.11";
}

