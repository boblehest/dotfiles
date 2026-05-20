stateVersion: { pkgs, ... }:
{
  system.stateVersion = stateVersion;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33; # TODO: bump when upgrading
    hostName = "files.home";
    config.adminpassFile = "/etc/nextcloud-secrets/nextcloud-admin-pass"; # TODO: move into secrets management
    config.dbtype = "sqlite";
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
