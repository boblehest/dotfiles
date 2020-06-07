{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.packages = with pkgs; [
      audacity 
      filezilla
      flameshot
      gimp
      jmtpfs
      transmission-gtk
      youtube-dl
    ] ++ lib.optionals cfg.workFeatures [
      openconnect
    ];

    programs.mpv = {
      enable = true;
    };
  }
