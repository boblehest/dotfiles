{ lib, config, pkgs, ... }:

with lib;

let
  cfg = import ../settings.nix;
  apRadio = "wlp0s20f3";
in
  {
    environment.etc."nextcloud-admin-pass".text = "hallo123";

    services = {
      nextcloud = {
        enable = false;
        package = pkgs.nextcloud27;
        hostName = "localhost";
        config.adminpassFile = "/etc/nextcloud-admin-pass";
      };

      jlo.wireguard = {
        enable = true;
        isServer = true;
        wanInterface = "wlp0s20f3";
        vpnInterface = "wg0";
        ipAddressWithSubnet = "10.13.37.1/24";
        listenPort = 43434;
        privateKeyFile = "/etc/wireguard-key";
        peers = [];
      };

      hostapd = {
        enable = false;
        radios.${apRadio} = {
          countryCode = "NO";
          networks.${apRadio} = {
            ssid = "fooWifi";
            ignoreBroadcastSsid = "empty";
            authentication = {
              mode = "wpa2-sha256";
              wpaPassword = "abcfoo12";
            };
          };
        };
      };

      haveged.enable = config.services.hostapd.enable; # Someone said that without haveged one could experience slow connection initialization or something (for people connecting to the access point?). I just added haveged without looking into it.
      dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
        enable = true;
        settings = {
          interface = apRadio;
          bind-interfaces = true;
          dhcp-range = [ "192.168.12.10,192.168.12.254,24h" ];
        };
      };

      fstrim.enable = true;
      upower.enable = true;

      seafile = {
        enable = false;
        adminEmail = "jlode90@gmail.com";
        initialAdminPassword = "superStrongPassword123";

        # package = 6434798a105930a9bd870689d1a505381ead762f
        ccnetSettings.General.SERVICE_URL = "127.0.0.1:8000";
      };

      # Onyx Boox Max 3
      udev.extraRules = "
      SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"05c6\", MODE=\"0666\"\nSUBSYSTEM==\"usb_device\", ATTRS{idVendor}==\"05c6\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"0925\", ATTR{idProduct}==\"3881\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1001\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1003\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1004\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1005\", MODE=\"0666\"\n
      SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", ATTR{idVendor}==\"21a9\", ATTR{idProduct}==\"1006\", MODE=\"0666\"\n
      ";
      udev.packages = [ pkgs.openocd ];

      displayManager.defaultSession = "none+i3";
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      xserver = mkMerge
      [
        {
          enable = true;

          config = ''
            Section "InputClass"
              Identifier "mouse accel"
              Driver "libinput"
              MatchIsPointer "on"
              Option "AccelProfile" "flat"
              Option "AccelSpeed" "0"
            EndSection
          '';

          # synaptics.enable = cfg.laptopFeatures;

          xkb = {
            layout = "us";
            variant = "altgr-intl";
            options = "compose:menu";
          };
          # desktopManager = {
          #   xterm.enable = false; # Is false by default since stateVersion 19.09
          # };
          windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
              rofi
              i3status
              i3lock
              i3blocks
            ];
            configFile = "/etc/nixos/dotfiles/home/i3/config";
          };
        }

        (mkIf cfg.swapCapsEscape {
          xkb.options = "caps:swapescape";
        })

        (mkIf cfg.intelVideo {
          videoDrivers = [ "intel" ];
          # I changed the DRI setting for reasons I can't recall. Maybe it was to run hagato?
          # Anyway, I'm currently experiencing that my terminal does not always refresh on
          # input, which is annoying, so I want to set this back to 2 once I'm done testing hagato.
          # Edit: I put it back, because I don't have any plans to run hagato again any time soon -- I just ran it to test that it compiled today.
          deviceSection = ''
            Option "DRI" "2"
            Option "TearFree" "true"
          '';
        })

        (mkIf cfg.nvidia {
          videoDrivers = [ "nvidia" ];
        })
      ];
    };
  }
