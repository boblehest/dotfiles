{ lib, config, pkgs, ... }:

with lib;

let
  cfg = import ../settings.nix;
in
{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    podman.enable = true;
    virtualbox.host.enable = false;
  };
  users.extraGroups.vboxusers.members =
    mkIf
    config.virtualisation.virtualbox.host.enable
    [ cfg.username ];

  environment.systemPackages =
    mkIf config.virtualisation.docker.enable [ pkgs.docker-compose ];
}
