{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.packages = with pkgs; [
      discord
      # weechat
    ] ++ lib.optionals cfg.workFeatures [
      slack
      teams
    ];
  }
