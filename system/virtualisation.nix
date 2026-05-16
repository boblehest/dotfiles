{ config, lib, pkgs, ... }:
{
  options.my.features.virtualisation = lib.mkEnableOption "virtualisation (Docker, Podman)";

  config = lib.mkIf config.my.features.virtualisation {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = false;
      };
      podman.enable = true;
    };

    environment.systemPackages =
      lib.mkIf config.virtualisation.docker.enable [ pkgs.docker-compose ];
  };
}
