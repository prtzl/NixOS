{ config, pkgs, ... }:

let
  ovmf = pkgs.OVMF.override {
    secureBoot = true;
    tpmSupport = true;
  };
in {
  virtualisation = {
    podman.enable = false; # haven't used it in ages
    docker.enable = false;
    # virtualbox.host.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        ovmf = {
          enable = true;
          #package = ovmf;
        };
        runAsRoot = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    libguestfs
    spice-gtk
    spice-vdagent
    virt-manager
    virt-viewer
    docker-compose
    podman-compose
  ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
}
