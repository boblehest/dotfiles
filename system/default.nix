{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./common.nix
    ./desktop.nix
    ./fonts.nix
    ./services.nix
    ./users.nix
    ./video.nix
    ./virtualisation.nix
  ];
}
