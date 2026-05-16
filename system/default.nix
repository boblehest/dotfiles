{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./common.nix
    ./desktop.nix
    ./disks.nix
    ./fonts.nix
    ./greeter.nix
    ./onyx-boox-max3.nix
    ./postgres.nix
    ./printing.nix
    ./sleep.nix
    ./users.nix
    ./video.nix
    ./video-conferencing.nix
    ./virtualisation.nix
    ./yubikey.nix
  ];
}
