{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.packages = with pkgs; [
      flameshot
      jmtpfs
      logseq
      # obsidian # removed because it relies on an insecure version of electron. TODO: Why do we even use an electron app?
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

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/apng" = "feh.desktop";
      };
    };
  }
