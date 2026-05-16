{ pkgs, ... }:
{
  config.my = {
    username = "jlo";
    hostName = "jlo-zrch";
    stateVersion = "25.05";
    conserveMemory = false;
    videoDrivers = [ "intel" ];
    features = {
      yubikey = true;
      zsaKeyboard = true;
      printing = true;
      sleep = true;
      postgres = true;
      virtualisation = true;
      onyxBoox = true;
      disks = true;
    };
  };

  # features.desktop = true by default, so not listed above

  config.my.services.wireguard = {
    enable = true;
    peerType = "client";
    vpnInterface = "wg0";
    ipAddressWithSubnet = "10.13.37.3/24";
    listenPort = 43434;
    privateKeyFile = "/etc/wireguard-key"; # TODO: move into secrets management
    peers = [
      {
        publicKey = "M4JnZkZ61lp1omaUOgR6M7G+7GTTZqSwWedei4X6Wlw=";
        allowedIPs = [ "10.13.37.0/24" ];
        endpoint = "92.220.73.158:43434";
      }
    ];
  };

  config.programs.openvpn3.enable = true;
  config.networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

  config.my.users.jlo.hm-config = import ../../home;

  config.home-manager.users.jlo = {
    my.swapCapsEscape = true;
    my.latex = false;
    programs.my.git = {
      enable = true;
      userName = "Jørn Lode";
      userEmail = "jl@zrch.com";
    };
  };
}
