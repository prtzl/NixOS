{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
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
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
