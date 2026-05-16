{ lib, ... }:
with lib;
{
  imports = [
    ./grafana.nix
    ./mediaserver.nix
    ./users.nix
    ./vpn.nix
  ];

  # Host identity options — feature options are declared in their respective modules.
  options.my = {
    stateVersion  = mkOption { type = types.str; };
    hostName      = mkOption { type = types.str; };
    username      = mkOption { type = types.str; };
    ntfsDriver    = mkEnableOption {};
    oldIntel      = mkEnableOption {};
    conserveMemory = mkEnableOption { default = true; };
  };
}
