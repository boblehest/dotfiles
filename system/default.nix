{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./common.nix
    ./desktop.nix
    ./fonts.nix
    ./printing.nix
    ./services.nix
    ./sleep.nix
    ./users.nix
    ./video.nix
    ./virtualisation.nix
  ];
}
