stateVersion: { pkgs, ... }:
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
      subidy = {
        url = "http://127.0.0.1:4533"; # TODO: point at navidrome container once containerised
        username = "meow";
        password = "meowmeow"; # TODO: move into secrets management
      };
    };
  };

  systemd.services.mopidy.environment.PIPEWIRE_RUNTIME_DIR = "/run/pipewire";

  networking.firewall.allowedTCPPorts = [
    6600 # MPD
    6680 # HTTP (iris web UI)
  ];
}
