{ lib, config, pkgs, ... }:

with lib;

{
  # Enable Docker
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  environment.systemPackages =
    mkIf config.virtualisation.docker.enable [ pkgs.docker-compose ];
}
