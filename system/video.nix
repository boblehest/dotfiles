{ config, lib, pkgs, ... }:

{
  options.my.videoDrivers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
  };

  config = {
    services.xserver.videoDrivers = config.my.videoDrivers;

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # Why is this installed for all hosts?
        intel-media-driver
      ];
    };
  };
}
