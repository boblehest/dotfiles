{ lib, config, pkgs, ... }:

with lib;

let
  cfg = import ../settings.nix;
in
  {
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

          xkb = {
            layout = "us";
            variant = "altgr-intl";
            options = "compose:menu";
          };
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
