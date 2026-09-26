stateVersion: { ... }:
{
  system.stateVersion = stateVersion;

  users.groups.media = { gid = 988; };
  users.users.navidrome.extraGroups = [ "media" ];

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/music";
      Address = "0.0.0.0";
      Port = 4533;
    };
  };

  networking.defaultGateway = "10.0.0.1";
  networking.firewall.allowedTCPPorts = [ 4533 ];
}
