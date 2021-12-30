{ config, lib, pkgs, modulesPath, ... }:

{

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

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.openrazer = {
    enable = true;
    users = [ "matej" ];
  };
}
