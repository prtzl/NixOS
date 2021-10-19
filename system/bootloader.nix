{ config, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    timeout = 5;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
      enable = true;
      fsIdentifier = "label";
      gfxmodeEfi = "1920x1080";
      theme = pkgs.nixos-grub2-theme;
    };
  };
}
