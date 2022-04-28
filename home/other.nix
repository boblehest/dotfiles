{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.packages = with pkgs; [
      flameshot
      jmtpfs
      obsidian
      transmission-gtk
      yt-dlp-light
      zotero
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
          push.default = "upstream";
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
