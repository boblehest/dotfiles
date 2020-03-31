{ pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./audio.nix
    ./boot.nix
    ./common.nix
    ./fonts.nix
    ./services.nix
    ./users.nix
    ./virtualisation.nix
  ];
}
