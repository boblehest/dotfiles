{ ... }:
{
  config.my = {
    username = "jlo";
    hostName = "jlo-laptop";
    stateVersion = "23.11";
    homeStateVersion = "25.05";
    conserveMemory = false;
    ntfsDriver = true;
    videoDrivers = [ "intel" ];
    disks.device = "/dev/nvme0n1";
    features = {
      postgres = true;
      virtualisation = true;
    };
  };

  config.my.services.wireguard = {
    enable = true;
    peerType = "client";
    vpnInterface = "wg0";
    ipAddressWithSubnet = "10.13.37.2/24";
    listenPort = 43434;
    privateKeyFile = "/etc/wireguard-key";
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
