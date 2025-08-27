{ pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./common.nix
    ./services.nix
    ./users.nix
    ./virtualisation.nix
  ];
}
