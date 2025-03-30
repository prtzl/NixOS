{ ... }:

{
  # Rational is that only real PC systems will support these modules
  # WSL can be nixos, but it's without graphics and "hardware", so this whole module can be excluded
  imports = [
    ./bootloader.nix
    ./filesystem.nix
    ./hardware-configuration_basic.nix
    ./virtualisation.nix
    ./udev.nix
  ];
}
