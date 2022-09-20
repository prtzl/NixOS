{ config, pkgs, ... }:

{
    home.packages = with pkgs; [ tio ];
    home.file.".tiorc".text = ''
      # Defaults
      baudrate = 115200
      databits = 8
      parity = none
      stopbits = 1
      color = 10

      [ftdi]
      tty = /dev/serial/by-id/usb-FTDI_TTL232R-3V3_FTGQVXBL-if00-port0
      baudrate = 115200
      log = enable
      log-file = /tmp/ftdi-serial.log
      color = 12

      [acm ports]
      pattern = acm([0-9]*)
      tty = /dev/ttyACM%s
      baudrate = 115200
      log = enable
      log-file = /tmp/acm-serial.log
      color = 15

      [usb devices]
      pattern = usb([0-9]*)
      tty = /dev/ttyUSB%s
      baudrate = 115200
      log = enable
      log-file = /tmp/usb-serial.log
      color = 13i

      [xil]
      pattern = xil([0-9]{1})
      tty = /dev/serial/by-id/usb-Xilinx_JTAG+3Serial_41678-if0%s-port0
      baudrate = 115200
      log = enable
      log-file = /tmp/xil-serial.log
      color = 14
    '';
}
