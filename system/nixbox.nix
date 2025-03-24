{ config, pkgs, lib, modulesPath, ... }:

{
  # Additional configuration
  imports = [
    ./packages/bootloader.nix
    ./packages/configuration_basic.nix
    ./packages/filesystem.nix
    ./packages/graphics.nix
    ./packages/hardware-configuration_basic.nix
    ./packages/pipewire.nix
    ./packages/udev.nix
    ./packages/virtualisation.nix
  ];

  system.stateVersion = "24.11";

  # set top 8x2 = packages that do build will take some time, but oh well
  nix.settings = {
    # max-jobs = maximum packages built at once
    max-jobs = 2;
    # cores = maximum threads used by a job/package
    cores = 16;
  };

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixbox";
    interfaces.enp9s0.useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [{
        from = 42000;
        to = 42001;
      }];
    };
    enableIPv6 = false;
  }; # Disable IPv6

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
      # Move keycode 135 (sometimes called Menu, looks like paper/screen with lines) to super key for better access from the right.
      # Probably specific to razer keyboard, but oh well
      displayManager.sessionCommands =
        "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 135 = Super_L' -display ''$DISPLAY";
    };
    fwupd.enable = true;
    udev = {
      extraRules = ''
        # Give CPU temp a stable device path
        # AMD Ryzen 7 3800x, Gigabyte B550M
        ACTION=="add", SUBSYSTEM=="hwmon", ATTRS{vendor}=="0x1022", ATTRS{device}=="0x1443", RUN+="/bin/sh -c 'ln -s /sys$devpath/temp3_input /dev/cpu_temp'"
      '';
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Set your time zone - where are you ?
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
        extraGroups = [
          "wheel"
          "libvirtd"
          "networkmanager"
          "dialout"
          "audio"
          "video"
          "usb"
          "podman"
          "docker"
          "openrazer"
          "kvm"
          "adbusers"
        ];
      };
    };
  };

  programs.wireshark.enable = true;

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    android-udev-rules
    xorg.xf86videoamdgpu
  ];

  # Hardware settings
  boot = {
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [
      "ipv6.disable=1"
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
  };

  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ext4";
    options = [ "defaults" "user" "rw" ];
  };
}
