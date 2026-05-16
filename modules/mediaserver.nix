{ config, lib, pkgs, ... }:

let cfg = config.my.services.mediaserver; in
{
  options.my.services.mediaserver.enable = lib.mkEnableOption "media server (navidrome, mopidy, transmission, lidarr, prowlarr, nzbget)";

  config = lib.mkIf cfg.enable {
    users.groups.music = {};
    users.users = {
      # So navidrome and nextcloud can both read the music library
      nextcloud.extraGroups = [ "music" ];
      navidrome.extraGroups = [ "music" ];
      lidarr.extraGroups = [ "transmission" "nzbget" ];
    };

    systemd.services = {
      lidarr.serviceConfig = {
        Group = lib.mkForce "";
        SupplementaryGroups = [ "nzbget" "transmission" ];
      };
      # Expose the nextcloud music library path into navidrome's sandbox
      navidrome.serviceConfig.BindReadOnlyPaths = [
        "/var/lib/nextcloud/data/jlo/files/music"
      ];
    };

    environment.systemPackages = with pkgs; [ unrar p7zip ];

    services = {
      lidarr.enable = true;
      prowlarr.enable = true;
      nzbget.enable = true;

      mopidy = {
        enable = true;
        extensionPackages = with pkgs; [ mopidy-iris mopidy-subidy ];
        settings = {
          http = {
            enabled = true;
            hostname = "0.0.0.0";
          };
          audio.output = "alsasink device=hw:1,0";
          subidy = {
            url = "http://127.0.0.1:4533";
            username = "meow";
            password = "meowmeow"; # TODO: move into secrets management
          };
        };
      };

      navidrome = {
        enable = true;
        settings = {
          Address = "0.0.0.0";
          MusicFolder = "/srv/music";
          Port = 4533;
        };
      };

      transmission = {
        enable = true;
        package = pkgs.transmission_4;
        settings = {
          rpc-bind-address = "0.0.0.0";
          rpc-whitelist-enabled = false;
        };
      };
    };
  };
}
