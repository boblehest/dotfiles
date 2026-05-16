{ config, lib, pkgs, ... }:
{
  options.my.features.yubikey = lib.mkEnableOption "YubiKey support";

  config = lib.mkIf config.my.features.yubikey {
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
  };
}
