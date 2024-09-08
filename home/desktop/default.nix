{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = import ./sway-config.nix { inherit config lib pkgs; };
  };

  programs = {
    waybar = {
      enable = true;
    } // (import ./waybar-config.nix);
    feh = {
      enable = true;
      keybindings = {
        save_filelist = null;
        toggle_fullscreen = "f";
      };
    };
    swaylock = {
      enable = true;
    };
    mpv = {
      enable = true;
      config = {
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
      };
    };
  };

  services = {
    jlo.battery-monitor.enable = true;
    jlo.shikane.enable = true;

    avizo = { # Notification daemon for volume and brightness adjustment
      enable = true;
      settings.default = {
        time = 2.0;
        height = 150;
      };
    };

    gammastep = { # "night mode" (screen color adjustment)
      enable = true;
      latitude = "60.38";
      longitude = "5.32";
      temperature = {
        day = 3200;
        night = 2800;
      };
    };

    mako = { # desktop notification daemon
      enable = true;
      defaultTimeout = 7000;
    };

    flameshot = { # screenshot utility
      enable = true;
      package = pkgs.flameshot.override { enableWlrSupport = true; };
      settings = {
        General = {
          disabledGrimWarning = true;
          disabledTrayIcon = true;
        };
      };
    };
  };

  home.packages = with pkgs; [
    chromium # for teams
    firefox
    networkmanagerapplet
    obsidian
    pavucontrol # pulseaudio volume control
    spotify
    transmission_4-gtk
    yt-dlp-light
    # zotero
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Make sure firefox takes precedence over chromium, if we have both
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";

      # Feh appears to be missing these associations by default
      "image/svg+xml" = "feh.desktop";
      "image/apng" = "feh.desktop";

      # Chromium seems to take precedence for these -- I don't like that
      "image/png" = "feh.desktop";
      "image/jpg" = "feh.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
