{ pkgs, ... }:

{
  services.udev = {
    packages = with pkgs; [
      stlink
      tio
      jlink
    ];
    extraRules = ''
      # Add all USB devices to usb group -> don't forget with your user
      KERNEL=="*", SUBSYSTEMS=="usb", MODE="0664", GROUP="usb"

      # RS232 devucesm yee
      SUBSYSTEMS=="usb", KERNEL=="ttyUSB[0-9]*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="sensors/ftdi_%s{serial}", GROUP="dialout"

      # Somehow added jlink file to udev does not get picked up :/
      ${builtins.readFile "${pkgs.jlink}/lib/udev/rules.d/99-jlink.rules"}
    '';
  };
}
