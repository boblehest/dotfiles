{ lib, config, pkgs, secretCfg, ... }:

with lib;

  {
    services = {
      # hardware.bolt.enable = true; # TODO What was this for? Work? (Charging via screen cable maybe?)
      # TODO Replace by OCIS
      nextcloud = {
        enable = false;
        package = pkgs.nextcloud29;
        hostName = "10.13.37.1";
        config.adminpassFile = "/etc/nextcloud-key";
      };

      gnome.gnome-keyring.enable = true; # for nextcloud client

      jlo.wireguard = {
        enable = true;
        isServer = false;
        vpnInterface = "wg0";
        ipAddressWithSubnet = "10.13.37.2/24";
        listenPort = 43434;
        privateKeyFile = "/etc/wireguard-key";
        peers = [
          # Server
          # TODO Do we regard this as a secret?
          {
            publicKey = "M4JnZkZ61lp1omaUOgR6M7G+7GTTZqSwWedei4X6Wlw=";
            allowedIPs = [ "10.13.37.0/24" ];
            endpoint = "84.215.130.16:43434";
          }
        ];
      };

      fstrim.enable = true;
      upower.enable = true;

      # Onyx Boox Max 3 (TODO: Move into own package/module)
      udev.extraRules = "
      SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"05c6\", MODE=\"0666\"\nSUBSYSTEM==\"usb_device\", ATTRS{idVendor}==\"05c6\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"0925\", ATTR{idProduct}==\"3881\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1001\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1003\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1004\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1005\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1006\", MODE=\"0666\"\n
      ";

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = ''
              ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd sway
            '';
            user = "greeter";
          };
        };
      };

      # TODO Move this into the wayland config, if applicable
      xserver = (mkIf secretCfg.intelVideo {
        videoDrivers = [ "intel" ];
        deviceSection = ''
            Option "DRI" "2"
            Option "TearFree" "true"
        '';
      });

      # TODO This is not supported by sway, and I should just either get rid
      # of nvidia or use another WM
      #   (mkIf secretCfg.nvidia {
      #     videoDrivers = [ "nvidia" ];
      #   })
    };

    environment.systemPackages = with pkgs; [
      rofi-wayland
      wl-clipboard
      i3status
    ];

    security.polkit.enable = true;
    security.pam.services.swaylock = {};
    programs = {
      light.enable = true;
      ssh.startAgent = true;
    };
  }
