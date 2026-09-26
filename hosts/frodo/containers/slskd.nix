stateVersion: { ... }:
{
  system.stateVersion = stateVersion;

  services.slskd = {
    enable = true;
    openFirewall = true;
    environmentFile = "/run/secrets/slskd-env";
    settings = {
      shares.directories = [ "/music" ];
      # Nested under the shared (read-only-in-sandbox) /music tree so systemd's
      # per-path sandboxing still lets slskd write here; navidrome picks it up
      # since it scans recursively, and it's shared over Soulseek either way.
      directories.downloads = "/music/downloads";
      web.port = 5030;
    };
  };

  networking.defaultGateway = "10.0.0.1";
  networking.firewall.allowedTCPPorts = [ 5030 ];
}
