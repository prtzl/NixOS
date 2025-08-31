{ pkgs, ... }:

{
  virtualisation = {
    podman.enable = false; # haven't used it in ages
    docker.enable = false;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        ovmf = {
          enable = true;
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
    # docker-compose
    # podman-compose
  ];
}
