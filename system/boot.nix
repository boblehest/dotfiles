{ config, lib, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = lib.mkIf config.jlo.oldIntel [ "intel_pstate=active" ];
    tmp.useTmpfs = ! config.jlo.conserveMemory;
    supportedFilesystems = lib.mkIf (config.jlo.ntfsDriver) [ "ntfs" ];

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
