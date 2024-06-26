{ config, lib, pkgs, secretCfg, ... }:

{
  boot = {
    # TODO Put these in "video conferencing" module
    # kernelModules = [ "v4l2loopback" ];
    # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # extraModprobeConfig = ''
    #   options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
    # '';

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = lib.mkIf secretCfg.oldIntel [ "intel_pstate=active" ];
    tmp.useTmpfs = ! secretCfg.conserveMemory;
    # supportedFilesystems = [ "ntfs" ]; # TODO Put this setting behind feature flag

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 40;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
}
