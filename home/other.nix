{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.packages = with pkgs; [
      # audacity
      # filezilla
      flameshot
      # gimp
      jmtpfs
      transmission-gtk
      yt-dlp-light
    ] ++ lib.optionals cfg.workFeatures [
      openconnect
    ];

    home.sessionVariables.EDITOR = "nvim";

    programs = {
      git = lib.mkMerge [ cfg.git {
        package = pkgs.gitMinimal;
        aliases = {
          st = "status -s";
          co = "checkout";
        };
        extraConfig = {
          init.defaultBranch = "master";
          pull.rebase = false;
        };
      }];
      mpv = {
        enable = true;
        config = {
          hwdec = "auto-safe";
          vo = "gpu";
          profile = "gpu-hq";
        };
      };
    };
  }
