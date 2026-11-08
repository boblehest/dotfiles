stateVersion: { config, pkgs, ... }:
{
  system.stateVersion = stateVersion;

  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [ mopidy-iris mopidy-subidy ];
    settings = {
      http = {
        enabled = true;
        hostname = "0.0.0.0";
      };
      audio.output = "pipewiresink";
      subidy.url = "http://10.0.0.4:4533";
    };
    # username/password come from the sops-rendered [subidy] section.
    extraConfigFiles = [ "/run/secrets/rendered/mopidy-subidy.conf" ];
  };

  systemd.services.mopidy.environment.PIPEWIRE_RUNTIME_DIR = "/run/pipewire";
  # The host runs PipeWire system-wide; its socket (bind-mounted from the host)
  # is only accessible to the "pipewire" group. Recreate that group here with
  # the same static GID so the permission check matches across the container.
  users.groups.pipewire.gid = config.ids.gids.pipewire;
  users.users.mopidy.extraGroups = [ "pipewire" ];

  networking.defaultGateway = "10.0.0.1";

  networking.firewall.allowedTCPPorts = [
    6600 # MPD
    6680 # HTTP (iris web UI)
  ];
}
