{ pkgs, config, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      left = "j";
      down = "k";
      up = "l";
      right = "semicolon";

      input."*" = {
        xkb_variant = "altgr-intl";
        xkb_layout = "us";
        xkb_options = "compose:menu,caps:swapescape";
        tap = "enabled";
        natural_scroll = "enabled";
        accel_profile = "flat";
        pointer_accel = "0.0";
        dwt = "enabled"; # disable touchpad while typing
      };

      fonts = {
        names = [ "Hack" ];
        style = "Regular";
        size = 12.0;
      };

      menu = "rofi"; # Why does this get its own config option in sway? Does wayland treat it specially?
      focus.wrapping = "force";

      # colors.focused = {
      #   border = "#4c7899";
      #   background = "#4488bb";
      #   text = "#ffffff";
      #   indicator = "#2e9ef4";
      #   childBorder = "#285577";
      # };

      colors.focused = {
        border = "#999999";
        background = "#5f676a";
        text = "#999999";
        indicator = "#999999";
        childBorder = "#999999";
      };
      colors.focusedInactive = {
        border = "#999999";
        background = "#5f676a";
        text = "#999999";
        indicator = "#999999";
        childBorder = "#999999";
      };
      colors.unfocused = {
        border = "#333333";
        background = "#222222";
        text = "#888888";
        indicator = "#292d2e";
        childBorder = "#1f1e1e";
      };
      colors.urgent = {
        border = "#999999";
        background = "#5f676a";
        text = "#999999";
        indicator = "#999999";
        childBorder = "#999999";
      };
      colors.placeholder = {
        border = "#000000";
        background = "#0c0c0c";
        text = "#ffffff";
        indicator = "#000000";
        childBorder = "#0c0c0c";
      };

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        # NOTE We unbind key 0 because it is bound to workspace 10. That in itself is fine,
        # but when generating the config, it ends up being the first switch-to-workspace binding,
        # (because the config generator probably sorts the key bindings before outputting them)
        # and apparently i3/sway uses that information to decide that workspace 10 should be the
        # first/leftmost workspace.
        keysToUnbind = ["Left" "Down" "Up" "Right" "0"];
        withOrWithoutShift = x: [
          x
          "Shift+${x}"
        ];
        keysToUnbind' = lib.concatMap withOrWithoutShift keysToUnbind;
        unbindKey = key: { name = "${modifier}+${key}"; value = null; }; 
        keyUnmappings = lib.listToAttrs (lib.map unbindKey keysToUnbind');

      in lib.mkOptionDefault ({
        "${modifier}+r" = "exec ${pkgs.rofi-wayland}/bin/rofi -show run";
        "${modifier}+t" = "exec ${pkgs.rofi-wayland}/bin/rofi -show window";
        "${modifier}+b" = "exec firefox";

        "${modifier}+h" = "splith";

        "${modifier}+Shift+minus" = null;
        "${modifier}+minus" = null;

        "${modifier}+Tab" = "focus output right";

        "${modifier}+q" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+s" = "floating toggle";
        "${modifier}+g" = "focus mode_toggle";
        "${modifier}+a" = "focus parent";
        "${modifier}+d" = "focus child";
        "${modifier}+Shift+z" = "move scratchpad";
        "${modifier}+z" = "scratchpad show";
        "${modifier}+x" = "exec swaylock";
        "${modifier}+bracketleft" = "workspace prev_on_output";
        "${modifier}+bracketright" = "workspace next_on_output";
        "XF86AudioPlay" = "exec \"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause\"";
        "XF86AudioStop" = "exec \"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop\"";
        "XF86AudioPrev" = "exec \"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous\"";
        "XF86AudioNext" = "exec \"dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next\"";

        "${modifier}+m" = "exec flameshot gui";
        "Ctrl+grave" = "exec makoctl dismiss --all";
        "Mod1+grave" = "exec makoctl restore";
      } // (
        keyUnmappings
        ));

      bars = [{
        hiddenState = "hide";
        mode = "hide";

        fonts = {
          names = [ "Hack" ];
          style = "Regular";
          size = 12.0;
        };
      }];

      seat."*".hide_cursor = "3000";

      floating.border = 4;
      window = {
        hideEdgeBorders = "smart";
        border = 4;
      };
    };

  };

  programs = {
    waybar.enable = true;
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
  };

  services = {
    kanshi.enable = true;

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
    # chromium # for teams
    firefox
    networkmanagerapplet
    pavucontrol # pulseaudio volume control
    spotify
  ];
}
