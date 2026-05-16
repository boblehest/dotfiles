{ config, lib, ... }:
{
  options.my.features.bluetooth = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf config.my.features.bluetooth {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
