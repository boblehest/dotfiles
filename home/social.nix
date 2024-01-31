{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.packages = with pkgs; [
    ] ++ lib.optionals cfg.workFeatures [
      obs-studio # for video conferencing
      chromium # teams doesn't work correctly in firefox
    ];
  }
