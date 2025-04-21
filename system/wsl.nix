{ lib, ... }:

{
  # Additional configuration
  imports = [ ./packages/system_base.nix <nixos-wsl/modules> ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "24.11";

  # set top 8x2 = packages that do build will take some time, but oh well
  nix.settings = {
    # max-jobs = maximum packages built at once
    max-jobs = 2;
    # cores = maximum threads used by a job/package
    cores = 8;
  };

  # Networking - check your interface name enp<>s0
  networking = {
    hostName = "nixbox";
    interfaces.eth0.useDHCP = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Set your time zone - where are you ?
  time.timeZone = "Europe/Ljubljana";

  # User sh$t
  programs.zsh.enable = true;
  users = {
    users = {
      nixos = {
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
}
