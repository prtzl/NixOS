{ config, pkgs, lib, modulesPath, ... }:

let
  p = package: ./. + "/packages/${package}";
in
{
  # Additional configuration
  imports = [
    (p "configuration_basic.nix")
    (p "graphics.nix")
    (p "virtualisation.nix")
  ];

  system.stateVersion = "24.05";

  # set top 8x2 = packages that do build will take some time, but oh well
  nix.settings = {
    # max-jobs = maximum packages built at once
    max-jobs = 8;
    # cores = maximum threads used by a job/package
    cores = 2;
  };

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixbox";
    interfaces.enp9s0.useDHCP = true;
    firewall = {
      enable = true;
    };
  };

  services = {
    xserver.videoDrivers = [ "amdgpu" ];
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Set your time zone - where are you ?
  location.provider = "geoclue2";
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = { font = "Lat2-Terminus16"; };

  # User sh$t
  programs.zsh.enable = true;
  users = {
    users = {
      matej = {
        isNormalUser = true;
        isSystemUser = false;
        createHome = true;
        extraGroups = [ "wheel" "libvirtd" "networkmanager" "dialout" "audio" "video" "usb" "podman" "docker" "openrazer" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
  ];

  # Hardware settings
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  # More stuff
  boot.kernelParams = [
    "noibrs"
    "noibpb"
    "nopti"
    "nospectre_v2"
    "nospectre_v1"
    "l1tf=off"
    "nospec_store_bypass_disable"
    "no_stf_barrier"
    "mds=off"
    "tsx=on"
    "tsx_async_abort=off"
    "mitigations=off"
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "performance";
  };

  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ext4";
    options = [ "defaults" "user" "rw" ];
  };
}
