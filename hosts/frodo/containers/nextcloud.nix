stateVersion: { pkgs, ... }:
{
  system.stateVersion = stateVersion;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud34; # TODO: bump when upgrading
    hostName = "files.home";
    config.adminpassFile = "/run/secrets/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };

  networking.defaultGateway = "10.0.0.1";
  networking.firewall.allowedTCPPorts = [ 80 ];
}
