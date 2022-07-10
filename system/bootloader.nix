{ config, pkgs, ... }:

{
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = { "vm.swappiness" = 0; };

  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = true;
    timeout = 3;
    efi = {
      canTouchEfiVariables = true;
      # For some reason this throws error: Directory "/boot/efi" is not the root of the file system.
      #efiSysMountPoint = "/boot/efi";
    };
  };
}
