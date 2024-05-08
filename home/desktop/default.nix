{ pkgs, config, ... }:

{
  programs = {
    feh = {
      enable = true;
      keybindings = {
        save_filelist = null;
        toggle_fullscreen = "f";
      };
    };
    rofi.enable = true;
  };

  services = {
    redshift = {
      enable = true;
      latitude = "60.38";
      longitude = "5.32";
      temperature = {
        day = 3200;
        night = 2800;
      };
    };

    dunst = {
      enable = true;
      settings = {
        global = {
          font = "Monospace 10";
          allow_markup = true;
          format = "<b>%s</b>\\n%b";
          geometry = "300x10-0-0";
          sticky_history = true;
          history_length = 50;
          padding = 8;
          horizontal_padding = 8;
        };
        frame = {
          width = 3;
          color = "#aaaaaa";
        };
        shortcuts = {
          close = "ctrl+grave";
          history = "mod1+grave";
        };
        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 10;
        };
        urgency_normal = {
          background = "#285577";
          foreground = "#ffffff";
          timeout = 20;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          timeout = 0;
        };
        ignore = {
          appname = "Spotify";
          format = "";
        };
      };
    };
    unclutter.enable = true;
  };


  home.packages = with pkgs; [
    firefox
    networkmanagerapplet
    pavucontrol
    spotify
    zathura 
  ];
}
