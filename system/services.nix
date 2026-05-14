{ lib, config, pkgs, secretCfg, ... }:

with lib;

  {
    # TODO: I assume that one of these two is enough. Why do I have both?
    # (Probably for desperate testing)
    users.users.lidarr.extraGroups = [ "transmission" "nzbget" ];
    systemd.services.lidarr.serviceConfig = {
      Group = lib.mkForce "";
      SupplementaryGroups = [ "nzbget" "transmission" ];
    };

    environment.systemPackages = with pkgs; [
      # for nzbget
      unrar
      p7zip
    ];

    # So that navidrome can access some files managed by nextcloud
    # (my nextcloud music library)
    users.groups.music = {};
    users.users.nextcloud.extraGroups = [ "music" ];
    users.users.navidrome.extraGroups = [ "music" ];

    # Because the NixOS module for navidrome sandboxes it, we need to manually
    # add paths we wish to expose to navidrome here:
    systemd.services.navidrome = {
      serviceConfig = {
        BindReadOnlyPaths = [ "/var/lib/nextcloud/data/jlo/files/music" ];
      };
    };

    services = {
      lidarr.enable = true;
      prowlarr.enable = true;
      nzbget.enable = true;

      mopidy = {
        enable = true;
        extensionPackages = [
          pkgs.mopidy-iris
          pkgs.mopidy-subidy
        ];
        settings = {
          http = {
            enabled = true;
            hostname = "0.0.0.0";
          };
          audio.output = "alsasink device=hw:1,0";
          subidy = {
            url = "http://127.0.0.1:4533";
            username = "meow";
            password = "meowmeow";
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
