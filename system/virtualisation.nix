{ lib, config, pkgs, ... }:

with lib;

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    podman.enable = true;
    # virtualbox.host.enable = true;
  };
  # users.extraGroups.vboxusers.members = [ config.username ]

  environment.systemPackages =
    mkIf config.virtualisation.docker.enable [ pkgs.docker-compose ];
}
