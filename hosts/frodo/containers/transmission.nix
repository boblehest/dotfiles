stateVersion: { ... }:
{
  system.stateVersion = stateVersion;

  users.groups.media = { gid = 988; };
  users.users.transmission.extraGroups = [ "media" ];

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/downloads/complete";
      incomplete-dir = "/downloads/incomplete";
      incomplete-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;
    };
  };

  networking.defaultGateway = "10.0.0.1";
  networking.firewall.allowedTCPPorts = [ 9091 51413 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
