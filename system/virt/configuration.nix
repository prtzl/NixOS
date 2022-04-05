{ lib, config, pkgs, ... }:

{
  # Additional configuration
  imports = [
      ../configuration_basic.nix
      ./hardware-configuration.nix
  ];

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "virtual";
    #networkmanager.enable = true;
    #useNetworkd = true;
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
  };
  
  # Set your time zone - where are you ?
  location.provider = "geoclue2";
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = { font = "Lat2-Terminus16"; };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

# User sh$t
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      test = {
        isNormalUser = true;
	    isSystemUser = false;
        createHome = true;
        extraGroups = [ "wheel" "libvirtd" "networkmanager" "dialout" "audio" "video" "usb" "podman" "docker" ];
      };
    };
  };
  home-manager.users.test = import ../../home/virt/home.nix;

  system.stateVersion = "21.11";
}

