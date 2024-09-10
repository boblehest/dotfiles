{ lib, ... }:
with lib;
{
  imports = [
    ./disks.nix
    ./video-conferencing.nix
    ./vpn.nix
    ./users.nix
  ];

  options.jlo = mkOption {
    type = types.submodule {
      options = {
        stateVersion = mkOption {
          type = types.str;
        };
        hostName = mkOption {
          type = types.str;
        };
        username = mkOption {
          type = types.str;
        };
        videoDrivers = mkOption {
          type = types.listOf types.str;
        };
        ntfsDriver = mkEnableOption {};
        oldIntel = mkEnableOption {};
        conserveMemory = mkEnableOption { default = true; };
      };
    };
    default = {};
  };
}
