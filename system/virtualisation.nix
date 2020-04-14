{ lib, config, pkgs, ... }:

with lib;

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  environment.systemPackages =
    mkIf config.virtualisation.docker.enable [ pkgs.docker-compose ];
}
