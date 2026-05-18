{ ... }:
{
  config.boot.kernel.sysctl."net.ipv4.ip_forward" = "1";

  config.networking.bridges.br-containers.interfaces = [];
  config.networking.interfaces.br-containers.ipv4.addresses = [{
    address = "10.0.0.1";
    prefixLength = 24;
  }];

  config.my.services.wireguard = {
    enable = true;
    peerType = "server";
    wanInterface = "enp1s0f1"; # TODO: verify interface name on actual hardware
    vpnInterface = "wg0";
    ipAddressWithSubnet = "10.13.37.1/24";
    listenPort = 43434;
    privateKeyFile = "/etc/wireguard-key"; # TODO: move into secrets management
    peers = [
      { # old laptop
        publicKey = "DQwMJJX6jIwjQU61Kn1MhnT/fX2H9gu6CkwhJIMwu3M=";
        allowedIPs = [ "10.13.37.2/32" ];
      }
      { # zrch laptop
        publicKey = "uFg7sGA178GsqDuz9SS5gldQ1yXGwkuPi3U4SDuK3lA=";
        allowedIPs = [ "10.13.37.3/32" ];
      }
      { # own s10 phone
        publicKey = "8PvKXOntHBI7oszz6/s0K3FdGm0GnETFkM9reX3ObwM=";
        allowedIPs = [ "10.13.37.4/32" ];
      }
      { # Johannes laptop
        publicKey = "Vk94F/yTIllVCedx4BngUZSWU62Kybw3b3gox1+nyAc=";
        allowedIPs = [ "10.13.37.5/32" ];
      }
      { # Johannes phone
        publicKey = "GeNfaUiBIuLk/CZqwb4SDTYW1Jx9L1XTJnzM4C2NMC4=";
        allowedIPs = [ "10.13.37.6/32" ];
      }
    ];
  };
}
