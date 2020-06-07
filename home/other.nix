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

    home.sessionVariables.EDITOR = "nvim";

    programs.mpv = {
      enable = true;
    };
  }
