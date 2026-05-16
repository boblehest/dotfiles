{ ... }:
{
  config.my = {
    username = "jlo";
    hostName = "jlo-laptop";
    stateVersion = "23.11";
    conserveMemory = false;
    ntfsDriver = true;
    videoDrivers = [ "intel" ];
    disk = "/dev/nvme0n1"; # TODO: verify
    features = {
      postgres = true;
      virtualisation = true;
      disks = true;
    };
  };

  config.my.services.wireguard = {
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
        # Using domain name instead of IP; if boot-time WireGuard fails, try
        # switching back to the raw IP (92.220.73.158) to rule out DNS ordering.
        endpoint = "lavpan.net:43434";
      }
    ];
  };

  config.services.gnome.gcr-ssh-agent.enable = false;

  config.my.users.jlo.hm-config = import ../../home;

  config.home-manager.users.jlo = {
    my.swapCapsEscape = true;
    my.latex = true;
    my.programs.git = {
      enable = true;
      userName = "Jørn Lode";
      userEmail = "jlode90@gmail.com";
    };
  };
}
