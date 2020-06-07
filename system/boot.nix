{ pkgs, ... }:

let
  cfg = import ../settings.nix;
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = ! cfg.conserveMemory;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}