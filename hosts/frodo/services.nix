{ ... }:
{
  services.dnsmasq = {
    enable = true;
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
      ];
    };
  };

  # Allow DNS queries from WireGuard clients
  networking.firewall.interfaces.wg0.allowedUDPPorts = [ 53 ];
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 53 ];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "files.home" = {
        locations."/".proxyPass = "http://10.0.0.3";
      };
      "homeassistant.home" = {
        locations."/".proxyPass = "http://10.0.0.10:8123";
      };
      "mopidy.home" = {
        locations."/".proxyPass = "http://10.0.0.2:6680";
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
