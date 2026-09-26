{ ... }:
{
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      bind-interfaces = true;
      listen-address = [ "10.13.37.1" "10.0.0.1" "192.168.10.200" ];
      no-resolv = true;
      server = [ "1.1.1.1" "8.8.8.8" ];
      # HTTP services point to frodo; nginx routes by hostname

      # TODO Consider abstracting this, to make it clear how the dnsmasq config
      # related to the nginx config (i.e. have one setting that writes both
      # dnsmasq config and nginx config)
      address = [
        "/files.home/10.0.0.1"
        "/homeassistant.home/10.0.0.1"
        "/mopidy.home/10.0.0.1"
        "/navidrome.home/10.0.0.1"
        "/slskd.home/10.0.0.1"
        "/transmission.home/10.0.0.1"
      ];
    };
  };

  # Allow DNS queries from WireGuard clients
  networking.firewall.interfaces.wg0.allowedUDPPorts = [ 53 ];
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 53 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "files.home" = {
        locations."/".proxyPass = "http://10.0.0.3";
      };
      "homeassistant.home" = {
        locations."/" = {
          proxyPass = "http://192.168.10.10:8123";
          proxyWebsockets = true;
        };
      };
      "mopidy.home" = {
        locations."/".proxyPass = "http://10.0.0.2:6680";
      };
      "navidrome.home" = {
        locations."/".proxyPass = "http://10.0.0.4:4533";
      };
      "slskd.home" = {
        locations."/" = {
          proxyPass = "http://10.0.0.6:5030";
          proxyWebsockets = true;
        };
      };
      "transmission.home" = {
        locations."/".proxyPass = "http://10.0.0.5:9091";
      };
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.pipewire.wireplumber.extraConfig."10-bluetooth" = {
    "monitor.bluez.properties" = {
      "bluez5.roles" = [ "a2dp_sink" "a2dp_source" ];
      "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" ];
      # Automatically connect a2dp_sink profile when a device pairs
      "bluez5.auto-connect" = [ "a2dp_sink" ];
    };
    "bluetooth.autoswitch-to-headset-profile" = false;
  };

  # WirePlumber has no Unit dependencies by default in system-wide mode
  systemd.services.wireplumber = {
    after = [ "pipewire.service" ];
    bindsTo = [ "pipewire.service" ];
    wantedBy = [ "pipewire.service" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
