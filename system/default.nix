{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./common.nix
    ./fonts.nix
    ./services.nix
    ./users.nix
    ./video.nix
    ./virtualisation.nix
  ];
}
