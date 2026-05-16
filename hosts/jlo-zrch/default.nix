{ pkgs, ... }:
{
  config.my = {
    username = "jlo";
    hostName = "jlo-zrch";
    stateVersion = "25.05";
    conserveMemory = false;
    videoDrivers = [ "intel" ];
    disk = "/dev/nvme0n1"; # TODO: verify
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
    my.programs.git = {
      enable = true;
      userName = "Jørn Lode";
      userEmail = "jl@zrch.com";
    };
    # TODO: Move into per-project devshells via GIT_CONFIG_COUNT/GIT_CONFIG_KEY_n/GIT_CONFIG_VALUE_n
    # env vars (git 2.31+), which layer on top of ~/.gitconfig without replacing it.
    programs.git.extraConfig.url."git@gitlab.zrch.cloud:".insteadOf = [
      "https://gitlab.com/"
      "https://gitlab.zrch.cloud/"
    ];
    home.packages = with pkgs; [
      slack
      vault
      lens           # k8s gui
      kubectl        # needed by lens
      kubelogin-oidc # needed by lens
      dbeaver-bin
    ];
  };
}
