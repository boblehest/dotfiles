{ config, lib, pkgs, ... }:

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
    gnome.gcr-ssh-agent.enable = false; # we already have ssh-agent; I trust that gnome keyring can use that one instead.

    jlo.wireguard = {
      enable = true;
      peerType = "client";
      vpnInterface = "wg0";
      ipAddressWithSubnet = "10.13.37.2/24";
      listenPort = 43434;
      privateKeyFile = "/etc/wireguard-key";
      peers = [
        {
          publicKey = "M4JnZkZ61lp1omaUOgR6M7G+7GTTZqSwWedei4X6Wlw=";
          allowedIPs = [ "10.13.37.0/24" ];
          # The computer fails to connect to wireguard at boot, and I'm thinking
          # it might be because it now depends on DNS to resolve it first. Try
          # changing this back to the actual IP address of the VPN server and
          # see if it fixes it. If so, try to figure out _how_ to make it work
          # when using the domain name.
          endpoint = "lavpan.net:43434";
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
