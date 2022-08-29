{ config, pkgs, ...}:

{
  services.udev = {
    packages = with pkgs; [ stlink tio jlink ];
    extraRules = ''
# Add all USB devices to usb group -> don't forget with your user
KERNEL=="*", SUBSYSTEMS=="usb", MODE="0664", GROUP="usb"

# RS232 devucesm yee
SUBSYSTEMS=="usb", KERNEL=="ttyUSB[0-9]*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="sensors/ftdi_%s{serial}", GROUP="dialout"

# JLINK - include rules manualy because somehow included jlink rules by the package
# are not used - even if they are placed in /etc/udev/rules.d/
${builtins.readFile "${pkgs.jlink}/lib/udev/rules.d/99-jlink.rules"}
    '';
  };
}   
