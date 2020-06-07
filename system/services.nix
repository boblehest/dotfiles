{ lib, pkgs, ... }:

with lib;

let
  cfg = import ../settings.nix;
in
  {
    services = {
      fstrim.enable = true;
      upower.enable = true;

      xserver = mkMerge
      [
        (mkIf cfg.laptopFeatures {
          xkbOptions = "caps:swapescape";
        })

        {
          enable = true;

          libinput.enable = true;
          config = ''
            Section "InputClass"
              Identifier "mouse accel"
              Driver "libinput"
              MatchIsPointer "on"
              Option "AccelProfile" "flat"
              Option "AccelSpeed" "0"
            EndSection
          '';

          layout = "us";
          xkbVariant = "altgr-intl";
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
