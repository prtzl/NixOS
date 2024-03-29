{ config, pkgs, lib, modulesPath, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  # Additional configuration
  imports = [
    (p "configuration_basic.nix")
  ];

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "testbox";
    interfaces.enp1s0.useDHCP = true;
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
      test = {
        isNormalUser = true;
        isSystemUser = false;
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" "dialout" "audio" "video" "usb" ];
      };
    };
  };

  # Hardware configuration
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
}
