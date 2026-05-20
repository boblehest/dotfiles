{ config, lib, ... }:
{
  options.my.disks = lib.mkOption {
    default = null;
    description = "Disko disk layout. Null disables disko for this host.";
    type = lib.types.nullOr (lib.types.submodule {
      options = {
        device = lib.mkOption {
          type = lib.types.str;
          description = "Target disk device, e.g. /dev/nvme0n1.";
        };
        swap = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "8G";
          description = "Size of swap partition at end of disk, or null for no swap.";
        };
      };
    });
  };

  config = lib.mkIf (config.my.disks != null) {
    disko.devices.disk.main = {
      type = "disk";
      device = config.my.disks.device;
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
            end = if config.my.disks.swap != null then "-${config.my.disks.swap}" else null;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [ "-L" "nixos" ];
            };
          };
        } // lib.optionalAttrs (config.my.disks.swap != null) {
          swap = {
            size = config.my.disks.swap;
            content.type = "swap";
          };
        };
      };
    };
  };
}
