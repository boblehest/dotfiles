{ config, lib, pkgs, ... }:
{
  options.my.features.zsaKeyboard = lib.mkEnableOption "ZSA keyboard";

  config = {
    hardware.keyboard.zsa.enable = config.my.features.zsaKeyboard;

    boot = lib.mkMerge [{
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "i915.enable_psr=0"
        "i915.enable_fbc=0"
      ];
      tmp.useTmpfs = ! config.my.conserveMemory;
      supportedFilesystems = lib.mkIf (config.my.ntfsDriver) [ "ntfs" ];

      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 40;
        };
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
    }
    (lib.mkIf config.my.oldIntel { kernelParams = [ "intel_pstate=active" ]; })
    ];
  };
}
