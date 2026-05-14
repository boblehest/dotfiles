{ config, lib, pkgs, ... }:

{
  # Work computer keyboard
  hardware.keyboard.zsa.enable = true;

  boot = lib.mkMerge [{
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "i915.enable_psr=0"
      "i915.enable_fbc=0"
    ];
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
  }
  (lib.mkIf config.jlo.oldIntel { kernelParams = [ "intel_pstate=active" ]; })
  ];
}
