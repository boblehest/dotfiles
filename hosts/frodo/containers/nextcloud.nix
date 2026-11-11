stateVersion: { pkgs, ... }:
{
  system.stateVersion = stateVersion;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud34; # TODO: bump when upgrading
    hostName = "files.home";
    config.dbtype = "sqlite";
    # Should match client_max_body_size of the host's reverse proxy
    maxUploadSize = "2G";
  };

  networking.defaultGateway = "10.0.0.1";
  networking.firewall.allowedTCPPorts = [ 80 ];
}
