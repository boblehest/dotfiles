{ ... }:
{
  imports = [
    ./backup.nix
    ./containers
    ./incus.nix
    ./network.nix
    ./services.nix
    ./users.nix
  ];

  config.sops.defaultSopsFile = ../../secrets/frodo.yaml;

  # Data drive for all service state (/srv/*). Formatted by hand, not by disko:
  #   mkfs.ext4 -L srv /dev/<disk>   (or `e2label /dev/<disk> srv` if already ext4)
  # No `nofail`: if the drive is missing, boot should stop rather than let the
  # containers start against an empty /srv on the root disk.
  config.fileSystems."/srv" = {
    device = "/dev/disk/by-label/srv";
    fsType = "ext4";
  };

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
