{ config, lib, pkgs, ... }:

{
  modifier = "Mod4";
  terminal = "alacritty";
  left = "j";
  down = "k";
  up = "l";
  right = "semicolon";

  input."*" = lib.mkMerge [
    {
      xkb_variant = "altgr-intl";
      xkb_layout = "us";
      tap = "enabled";
      natural_scroll = "enabled";
      accel_profile = "flat";
      pointer_accel = "0.0";
      dwt = "enabled"; # disable touchpad while typing
    }
    (lib.mkIf (config.jlo.swapCapsEscape) {
      xkb_options = "compose:menu,caps:swapescape";
    })
  ];

  fonts = {
    names = [ "Hack" ];
    style = "Regular";
    size = 12.0;
  };

  menu = "rofi"; # Why does this get its own config option in sway? Does wayland treat it specially?
  focus.wrapping = "force";

  colors = {
    focused = {
      border = "#999999";
      background = "#458096";
      text = "#ffffff";
      indicator = "#999999";
      childBorder = "#999999";
    };
    focusedInactive = {
      border = "#999999";
      background = "#5f676a";
      text = "#999999";
      indicator = "#999999";
      childBorder = "#999999";
    };
    unfocused = {
      border = "#333333";
      background = "#222222";
      text = "#888888";
      indicator = "#292d2e";
      childBorder = "#1f1e1e";
    };
  };

  keybindings =
    let
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

    "XF86AudioRaiseVolume" = "exec volumectl -u up";
    "XF86AudioLowerVolume" = "exec volumectl -u down";
    "XF86AudioMute" = "exec volumectl toggle-mute";
    "XF86AudioMicMute" = "exec volumectl -m toggle-mute";

    "XF86MonBrightnessUp" = "exec lightctl up";
    "XF86MonBrightnessDown" = "exec lightctl down";

    "${modifier}+m" = "exec flameshot gui";
    "Ctrl+grave" = "exec makoctl dismiss --all";
    "Mod1+grave" = "exec makoctl restore";
  } // keyUnmappings);

  bars = [{
    id = "bar";
    hiddenState = "hide";
    mode = "hide";
    command = "waybar";

    fonts = {
      names = [ "Hack" ];
      style = "Regular";
      size = 16.0;
    };
  }];

  seat."*".hide_cursor = "3000";

  floating.border = 4;
  window = {
    hideEdgeBorders = "smart";
    # TODO The hm module doesn't support setting the --i3 flag, so we'll have
    # to add it ourselves when we can be fucked to.
    # hideEdgeBorders = "--i3 smart";
    # I suggest this format, and add a renamedmodule thingy to make it redirect
    # the mode
    # hideEdgeBorders = {
    #   mode = "smart";
    #   i3Compatible = true;
    # }
    border = 4;
  };
}
