{ lib, pkgs, ... }:

let
  cfg = import ../settings.nix;
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = lib.mkIf cfg.oldIntel [ "intel_pstate=active" ];
    tmpOnTmpfs = ! cfg.conserveMemory;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
