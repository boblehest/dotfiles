{ config, lib, ... }:
{
  options.my.features.disks = lib.mkEnableOption "standard disk layout (nixos/boot labels)";
  options.my.swap = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "8G";
    description = "Size of swap partition at end of disk, or null for no swap.";
  };

  options.my.disk = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Target disk device, e.g. /dev/nvme0n1. Required when my.features.disks is enabled.";
  };

  config = lib.mkIf config.my.features.disks {
    assertions = [{
      assertion = config.my.disk != "";
      message = "my.disk must be set when my.features.disks is enabled";
    }];

    disko.devices.disk.main = {
      type = "disk";
      device = config.my.disk;
      content = {
        type = "gpt";
        partitions = {
          # Partitions are created in alphabetical key order: boot → root → swap
          boot = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              extraArgs = [ "-n" "boot" ];
              mountOptions = [ "fmask=0022" "dmask=0022" ];
            };
          };
          root = {
            end = if config.my.swap != null then "-${config.my.swap}" else "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [ "-L" "nixos" ];
            };
          };
        } // lib.optionalAttrs (config.my.swap != null) {
          swap = {
            end = "100%";
            content.type = "swap";
          };
        };
      };
    };
  };
}
