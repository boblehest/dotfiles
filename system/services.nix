{ config, lib, pkgs, ... }:

{
  services = {
    # yubikey
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;

    hardware.bolt.enable = true; # TODO What was this for? Work? (Charging via screen cable maybe?)
    # TODO Replace by OCIS
    # TODO Put into own module?
    nextcloud = {
      enable = false;
      package = pkgs.nextcloud29;
      hostName = "10.13.37.1";
      config.adminpassFile = "/etc/nextcloud-key";
    };

    postgresql = {
      enable = true;
      settings.port = 5433;
      ensureDatabases = [ "mydatabase" ];
      authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all      all     trust
      host  all      all     127.0.0.1/32   trust
      host  all      all     ::1/128        trust
      '';
    };

    gnome.gnome-keyring.enable = true; # for nextcloud client
    # gnome.gcr-ssh-agent.enable = false;

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
          endpoint = "92.220.73.158:43434";
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
    openvpn3.enable = true; # for zrch vpn? cant remember
    light.enable = true;
    ssh.startAgent = true;
  };
}
