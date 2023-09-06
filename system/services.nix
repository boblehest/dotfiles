{ lib, config, pkgs, ... }:

with lib;

let
  cfg = import ../settings.nix;
  apRadio = "wlp0s20f3";
in
  {
    services = {
      hostapd = {
        # TODO Test if phone and laptop nic support SAE authentication
        enable = true;
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

      haveged.enable = config.services.hostapd.enable; # Someone said that without haveged one could experience slow connection initialization or something. I just added haveged without looking into it.
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

      # Onyx Boox Max 3
      udev.extraRules = "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"05c6\", MODE=\"0666\"\nSUBSYSTEM==\"usb_device\", ATTRS{idVendor}==\"05c6\", MODE=\"0666\"\n";

      xserver = mkMerge
      [
        (mkIf cfg.swapCapsEscape {
          xkbOptions = "caps:swapescape";
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

        {
          enable = true;

          libinput = {
            enable = true;
            touchpad.naturalScrolling = true;
          };
          config = ''
            Section "InputClass"
              Identifier "mouse accel"
              Driver "libinput"
              MatchIsPointer "on"
              Option "AccelProfile" "flat"
              Option "AccelSpeed" "-0.75"
            EndSection
          '';

          # synaptics.enable = cfg.laptopFeatures;

          layout = "us";
          xkbVariant = "altgr-intl";
          xkbOptions = "compose:menu";
          desktopManager = {
            xterm.enable = false;
          };
          displayManager.defaultSession = "none+i3";
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
      ];
    };
  }
