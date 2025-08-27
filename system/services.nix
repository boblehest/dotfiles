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
        package = pkgs.nextcloud30;
        hostName = "10.13.37.1";
        config.adminpassFile = "/etc/nextcloud-admin-pass";
      };

      jlo.wireguard = {
        enable = true;
        isServer = true;
        wanInterface = "enp1s0f1";
        vpnInterface = "wg0";
        ipAddressWithSubnet = "10.13.37.1/24";
        listenPort = 8080;
        privateKeyFile = "/etc/wireguard-key";
        peers = [
          {
            publicKey = "DQwMJJX6jIwjQU61Kn1MhnT/fX2H9gu6CkwhJIMwu3M=";
            allowedIPs = [ "10.13.37.2/32" ];
          }
          {
            publicKey = "IrYSpdjzrf37yfEoYgNeZaskcecsmdlwFA9yWY9Y8QM=";
            allowedIPs = [ "10.13.37.3/32" ];
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
