{ config, lib, pkgs, secretCfg, ... }:

{
  boot = {
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
