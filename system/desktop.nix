{ config, lib, pkgs, ... }:
{
  options.my.features.desktop = lib.mkEnableOption "desktop environment (Sway, greetd, Waybar)" // { default = true; };

  config = lib.mkMerge [
    {
      # Sub-features default to whatever desktop is set to, but can be
      # individually overridden in host config.
      my.features.audio     = lib.mkDefault config.my.features.desktop;
      my.features.bluetooth = lib.mkDefault config.my.features.desktop;
      my.features.greeter   = lib.mkDefault config.my.features.desktop;
    }
    (lib.mkIf config.my.features.desktop {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        config.common.default = [ "wlr" ];
      };
      services.gnome.gnome-keyring.enable = true;
      services.gnome.gcr-ssh-agent.enable = false; # using programs.ssh.startAgent instead
      services.hardware.bolt.enable = true;
      security.polkit.enable = true;
      security.pam.services.swaylock = {};
      programs.light.enable = true;
      environment.systemPackages = with pkgs; [ rofi wl-clipboard capitaine-cursors ];
    })
  ];
}
