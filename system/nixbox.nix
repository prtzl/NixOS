{ lib, ... }:

{
  # Additional configuration
  imports = [
    ./packages/system_base.nix
    ./packages/system_graphics.nix
    ./packages/system_hardware.nix
  ];

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
    firewall = { enable = true; };
    enableIPv6 = false;
  }; # Disable IPv6

  services = {
    udev = {
      extraRules = ''
        # Give CPU temp a stable device path
        # 1: Find the cpu temperature hwmon device: cat /sys/class/hwmon/hwmon{1..9}/name
        # 2: Find one with the name that would be of the cpu monitor device. Intel laptop has dedicated "coretemp", amd has a device
        # 3: Find the temperature input of the cpu core dye in the hwmon device
        # 4.a: Find unique way to find the device either by vendor/product ID (like a chip/driver) or if it's dedicated (intel coretemp) by "name"
        # 4.b: Run: udevadm info --attribute-walk --path=/sys/class/hwmon/hwmon<number> to get unique info mentioned above
        # 5: Copy pase bottom code and either use vendor/product id, name, or whatever else. For various temperatures be sure to rename the link under which it will be available!
        # AMD Ryzen 7 3800x, Gigabyte B550M
        ACTION=="add", SUBSYSTEM=="hwmon", ATTRS{vendor}=="0x1022", ATTRS{device}=="0x1443", RUN+="/bin/sh -c 'ln -s /sys$devpath/temp3_input /dev/cpu_temp'"

        # Create GPU core temp aliases with use of vid and pid of the card/interface
        ACTION=="add", SUBSYSTEM=="hwmon", ATTRS{vendor}=="0x1002", ATTRS{device}=="0x67df", RUN+="/bin/sh -c 'ln -s /sys$devpath/temp1_input /dev/gpu_temp'"
        ACTION=="add", SUBSYSTEM=="hwmon", ATTRS{vendor}=="0x1002", ATTRS{device}=="0x67df", RUN+="/bin/sh -c 'ln -s /sys$devpath/power1_input /dev/gpu_power'"
      '';
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Set your time zone - where are you ?
  # Since each nixos could be anywhere, define it in each nixos config.
  time.timeZone = "Europe/Ljubljana";

  # User sh$t
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

      "amdgpu.dpm=1"
      "amdgpu.dc=1"
      "amdgpu.ppfeaturemask=0xfffd7fff"
    ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  fileSystems."/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ext4";
    options = [ "defaults" "user" "rw" ];
  };
}
