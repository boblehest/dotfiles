{ lib, config, pkgs, secretCfg, ... }:

with lib;

  {
    services = {
      services.lidarr = {
        enable = true;
        settings.server.port = 8686;
      };
      services.navidrome = {
        enable = true;
        settings = {
          Address = "0.0.0.0";
          Port = 4533;
        };
      };


      nextcloud = {
        enable = true;
        package = pkgs.nextcloud33;
        hostName = "10.13.37.1";
        config.adminpassFile = "/etc/nextcloud-admin-pass";
        config.dbtype = "sqlite";
      };

      jlo.wireguard = {
        enable = true;
        isServer = true;
        wanInterface = "enp1s0f1";
        vpnInterface = "wg0";
        ipAddressWithSubnet = "10.13.37.1/24";
        listenPort = 43434;
        privateKeyFile = "/etc/wireguard-key";
        peers = [
          { # private laptop
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

      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      fstrim.enable = true;
      upower.enable = true;
    };
  }
