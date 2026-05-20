{ config, ... }:
let stateVersion = config.my.stateVersion; in
{
  containers.mopidy = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.2/24";
    bindMounts."/run/pipewire" = {
      hostPath = "/run/pipewire";
      isReadOnly = false;
    };
    config = import ./mopidy.nix stateVersion;
  };

  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.3/24";
    bindMounts = {
      "/etc/nextcloud-secrets" = {
        hostPath = "/etc/nextcloud-secrets"; # TODO: move into secrets management
        isReadOnly = true;
      };
      "/var/lib/nextcloud" = {
        hostPath = "/srv/nextcloud";
        isReadOnly = false;
      };
    };
    config = import ./nextcloud.nix stateVersion;
  };

  # TODO: navidrome, transmission, lidarr, prowlarr, nzbget
}
