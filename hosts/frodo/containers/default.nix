{ config, ... }:
let stateVersion = config.my.stateVersion; in
{
  users.groups.media = { gid = 988; };

  sops.secrets = {
    nextcloud-admin-pass = { mode = "0444"; };
    # Only consumed via the mopidy-subidy.conf template below; stays root-only.
    mopidy-subidy-password = {};
    slskd-env = { mode = "0444"; };
  };

  sops.templates."mopidy-subidy.conf" = {
    mode = "0444";
    content = ''
      [subidy]
      username = meow
      password = ${config.sops.placeholder.mopidy-subidy-password}
    '';
  };

  systemd.tmpfiles.rules = [
    "d /srv/music                2775 root media - -"
    "d /srv/navidrome            2775 root media - -"
    "d /srv/transmission         2775 root media - -"
    "d /srv/downloads            2775 root media - -"
    "d /srv/downloads/complete   2775 root media - -"
    "d /srv/downloads/incomplete 2775 root media - -"
    "d /srv/slskd                2775 root media - -"
  ];

  # TODO Consider abstracting this, so that we don't have to specify hostBridge,
  # and also to add a DNS record to dnsmasq for the service.
  containers.mopidy = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.2/24";
    bindMounts = {
      "/run/pipewire" = {
        hostPath = "/run/pipewire";
        isReadOnly = false;
      };
      "/run/secrets/rendered/mopidy-subidy.conf" = {
        hostPath = config.sops.templates."mopidy-subidy.conf".path;
        isReadOnly = true;
      };
    };
    config = import ./mopidy.nix stateVersion;
  };

  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.3/24";
    bindMounts = {
      "/run/secrets/nextcloud-admin-pass" = {
        hostPath = config.sops.secrets.nextcloud-admin-pass.path;
        isReadOnly = true;
      };
      "/var/lib/nextcloud" = {
        hostPath = "/srv/nextcloud";
        isReadOnly = false;
      };
    };
    config = import ./nextcloud.nix stateVersion;
  };

  containers.navidrome = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.4/24";
    bindMounts = {
      "/music" = {
        hostPath = "/srv/music";
        isReadOnly = true;
      };
      "/var/lib/navidrome" = {
        hostPath = "/srv/navidrome";
        isReadOnly = false;
      };
    };
    config = import ./navidrome.nix stateVersion;
  };

  containers.transmission = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.5/24";
    bindMounts = {
      "/downloads" = {
        hostPath = "/srv/downloads";
        isReadOnly = false;
      };
      "/var/lib/transmission" = {
        hostPath = "/srv/transmission";
        isReadOnly = false;
      };
    };
    config = import ./transmission.nix stateVersion;
  };

  containers.slskd = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-containers";
    localAddress = "10.0.0.6/24";
    bindMounts = {
      "/music" = {
        hostPath = "/srv/music";
        isReadOnly = false; # slskd writes downloads into /music/downloads
      };
      "/var/lib/slskd" = {
        hostPath = "/srv/slskd";
        isReadOnly = false;
      };
      "/run/secrets/slskd-env" = {
        hostPath = config.sops.secrets.slskd-env.path;
        isReadOnly = true;
      };
    };
    config = import ./slskd.nix stateVersion;
  };
}
