{ config, lib, pkgs, ... }:

with lib;

{
  services = {
    hardware.bolt.enable = true; # TODO What was this for? Work? (Charging via screen cable maybe?)
    # TODO Replace by OCIS
    # TODO Put into own module?
    nextcloud = {
      enable = false;
      package = pkgs.nextcloud29;
      hostName = "10.13.37.1";
      config.adminpassFile = "/etc/nextcloud-key";
    };

    gnome.gnome-keyring.enable = true; # for nextcloud client

    jlo.wireguard = {
      enable = true;
      peerType = "client";
      vpnInterface = "wg0";
      ipAddressWithSubnet = "10.13.37.3/24";
      listenPort = 43434;
      privateKeyFile = "/etc/wireguard-key";
      peers = [
        {
          publicKey = "M4JnZkZ61lp1omaUOgR6M7G+7GTTZqSwWedei4X6Wlw=";
          allowedIPs = [ "10.13.37.0/24" ];
          endpoint = "84.215.130.16:43434";
        }
      ];
    };

    fstrim.enable = true;
    upower.enable = true;

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

    xserver.videoDrivers = config.jlo.videoDrivers;
    # deviceSection = ''
    #     Option "DRI" "2"
    #     Option "TearFree" "true"
    # '';
  };

  environment.systemPackages = with pkgs; [
    rofi-wayland
    wl-clipboard
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  programs = {
    light.enable = true;
    ssh.startAgent = true;
  };
}
