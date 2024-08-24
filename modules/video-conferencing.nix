{ config, lib, pkgs, ... }:

let
  cfg = config.jlo.video-conferencing;
in {
  options.jlo.video-conferencing = {
    enable = lib.mkEnableOption {};
  };
  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "v4l2loopback" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
      '';
    };
  };
}
