{ config, lib, ... }:

{
  # Additional configuration
  imports = [
    ./packages/system_base.nix
    ./packages/system_graphics.nix
    ./packages/system_hardware.nix
  ];

  # set to 4x2 = packages that do build will take some time, but oh well
  nix.settings = {
    # max-jobs = maximum packages built at once
    max-jobs = 2;
    # cores = maximum threads used by a job/package
    cores = 8;
  };

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixtop";
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp61s0.useDHCP = true;
    firewall = { enable = true; };
    enableIPv6 = false;
  };

  # Set your time zone - where are you ?
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
        ];
      };
    };
  };

  services = {
    acpid.enable = true;
    blueman.enable = true;
    hardware.bolt.enable = true;
    throttled.extraConfig = "";
    tlp.settings = {
      # Do not suspend USB devices
      USB_AUTOSUSPEND = 0;
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
    udev = {
      extraRules = ''
        # Give CPU temp a stable device path
        # Intel i7 8550U
        ACTION=="add", SUBSYSTEM=="hwmon", ATTRS{name}=="coretemp", RUN+="/bin/sh -c 'ln -s /sys$devpath/temp1_input /dev/cpu_temp'"
      '';
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Hardware configuration
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "thunderbolt"
    ];
    initrd.kernelModules = [ ];
    kernelModules =
      [ "kvm-intel" "acpi_call" "vboxdrv" "vboxnetflt" "vboxnetadp" "vboxpci" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
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

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware = {
    # Following line fixed missing drivers for the wireless card when upgrading from 24.11 to 25.05.
    enableAllFirmware = true;
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
    acpilight.enable = true;
  };
}
