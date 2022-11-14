{ config, pkgs, ... }:

{
  # Additional configuration
  imports = [
    ./hardware-configuration.nix
    ../configuration_basic.nix
    ../graphics.nix
    ../virtualisation.nix
  ];

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixbox";
    interfaces.enp9s0.useDHCP = true;
  };

  # Set your time zone - where are you ?
  location.provider = "geoclue2";
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = { font = "Lat2-Terminus16"; };

  # User sh$t
  users = {
    users = {
      matej = {
        isNormalUser = true;
        isSystemUser = false;
        createHome = true;
        extraGroups = [ "wheel" "libvirtd" "networkmanager" "dialout" "audio" "video" "usb" "podman" "docker" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
  ];
}

