{ config, lib, pkgs, ... }:
let
  # Wildcard covers every public service (blog.noand.no, ...), so new ones
  # need no DNS changes.
  hostnames = [ "noand.no" "*.noand.no" ];
in
{
  # Gigahost API key (Account → API); noand.no's DNS is hosted there
  config.sops.secrets.gigahost-api-key = {};

  # Gigahost's dyndns2-style endpoint; same call ddns-updater's (as yet
  # unreleased) gigahostno provider makes. Creates the A record if missing.
  config.systemd.services.gigahost-ddns = {
    description = "Point noand.no DNS records at our public IPv4";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.curl ];
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      StateDirectory = "gigahost-ddns";
      LoadCredential = "apikey:${config.sops.secrets.gigahost-api-key.path}";
    };
    script = ''
      ip=$(curl -sS4 --max-time 10 https://ipv4.icanhazip.com)
      if [[ ! $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Could not determine public IP (got: $ip)" >&2
        exit 1
      fi

      # Only call the API when the IP changed since the last successful update
      state=$STATE_DIRECTORY/ip
      [[ "$(cat "$state" 2>/dev/null)" == "$ip" ]] && exit 0

      for host in ${lib.escapeShellArgs hostnames}; do
        # Header via stdin config, so the key never shows up in the process list
        resp=$(printf 'header = "Authorization: Bearer %s"\n' "$(cat "$CREDENTIALS_DIRECTORY/apikey")" \
          | curl -sS --max-time 30 -K - -G \
              --data-urlencode "hostname=$host" \
              --data-urlencode "myip=$ip" \
              https://api.gigahost.no/api/v0/dns/dyndns)
        echo "$host: $resp"
        case "$resp" in
          good*|nochg*) ;;
          *) exit 1 ;;
        esac
      done
      echo "$ip" > "$state"
    '';
  };

  config.systemd.timers.gigahost-ddns = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1h";
    };
  };
}
