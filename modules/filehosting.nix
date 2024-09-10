{ lib, ... }:
let
  cfg = config.services.jlo.fileserver;
in {
  options.services.jlo.fileserver = {
    enable = lib.mkEnableOption {};
  };
  config.services.nextcloud = {
    enable = cfg.enable;
    package = pkgs.nextcloud29;
    hostName = "10.13.37.1";
    # TODO Use SOPS
    config.adminpassFile = "/etc/nextcloud-key";
  };
}
