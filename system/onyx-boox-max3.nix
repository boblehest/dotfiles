{ config, lib, ... }:
{
  options.my.features.onyxBoox = lib.mkEnableOption "Onyx Boox e-reader udev rules";

  config = lib.mkIf config.my.features.onyxBoox {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="05c6", MODE="0666"
      SUBSYSTEM=="usb_device", ATTRS{idVendor}=="05c6", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1001", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1004", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"
    '';
  };
}
