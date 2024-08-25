{ pkgs, lib, secretCfg, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    jmtpfs
    niv
    obsidian
    transmission_4-gtk
    yt-dlp-light
    zotero
  ];

  jlo.services.battery-monitor.enable = true;

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.GOPATH = "/home/jlo/.cache/go"; # TODO don't hardcode home path

  programs = {
    git = lib.mkMerge [
      secretCfg.git
      {
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
      }
    ];
    mpv = {
      enable = true;
      config = {
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
      };
    };
  };

  services.nextcloud-client.enable = true;

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "feh.desktop";
      "image/apng" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      };
      };
      }
