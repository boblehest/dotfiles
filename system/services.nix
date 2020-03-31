{ lib, pkgs, ... }:

with lib;

let cfg = import ../settings.nix;
in
{
  services = {
    # Enable FSTrim for SSD health
    fstrim.enable = true;
    # Enable power support for applications
    upower.enable = true;

    # Enable the X11 windowing system.
    xserver = mkMerge
    [
      (mkIf cfg.laptopFeatures {
        libinput.enable = true;
        xkbOptions = "caps:swapescape";
      })

      {
      enable = true;
      layout = "us,no";
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
      };
    }
  ];
  };
}
