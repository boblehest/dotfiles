{ config, lib, ... }:

let
  cfg = config.jlo;
in
{
  options.jlo.videoDrivers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };
  config.services.xserver.videoDrivers = cfg.videoDrivers;
}

