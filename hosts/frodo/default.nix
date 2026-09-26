{ ... }:
{
  imports = [
    ./containers
    ./incus.nix
    ./network.nix
    ./services.nix
    ./users.nix
  ];

  config.sops.defaultSopsFile = ../../secrets/frodo.yaml;

  config.my = {
    username = "jlo";
    hostName = "frodo";
    stateVersion = "25.05";
    homeStateVersion = "25.05";
    disks = { device = "/dev/nvme0n1"; swap = "8G"; };
    videoDrivers = [];
    features = {
      desktop = false;
      sleep = false;
      audio = "system";
    };
  };
}
