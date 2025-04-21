{ lib, ... }:

{
  # Additional configuration
  imports = [
    ./packages/system_base.nix
    ./packages/system_graphics.nix
    ./packages/system_hardware.nix
  ];

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "testbox";
    interfaces.enp1s0.useDHCP = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Set your time zone - where are you ?
  location.provider = "geoclue2";
  time.timeZone = "Europe/Ljubljana";

  # User sh$t
  users = {
    users = {
      test = {
        isNormalUser = true;
        isSystemUser = false;
        createHome = true;
        extraGroups =
          [ "wheel" "networkmanager" "dialout" "audio" "video" "usb" ];
      };
    };
  };

  # Hardware configuration
  boot = {
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
}
