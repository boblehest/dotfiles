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

    programs = {
      git = {
        enable = true;
        package = pkgs.gitMinimal;
        aliases = {
          st = "status -s";
          co = "checkout";
        };
      };
      mpv.enable = true;
    };
  }
