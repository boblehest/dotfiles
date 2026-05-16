{ config, lib, ... }:
{
  options.my.features.disks = lib.mkEnableOption "standard disk layout (nixos/boot labels)";

  config = lib.mkIf config.my.features.disks {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };
}
