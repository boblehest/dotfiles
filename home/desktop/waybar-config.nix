{
  settings.bar = {
    # -------------------------------------------------------------------------
    # Global configuration
    # -------------------------------------------------------------------------
    ipc = true; # sway won't be able to hide the bar without this.

    layer = "top";

    position = "bottom";

    modules-left = [
      "sway/workspaces"
      # "sway/mode"
      # "custom/media"
    ];
    modules-center = [
      "sway/window"
    ];
    modules-right = [
      "tray"
      "bluetooth"
      "pulseaudio"
      "network"
      "battery"
      "clock"
    ];


    # -------------------------------------------------------------------------
    # Modules
    # -------------------------------------------------------------------------

    "sway/workspaces" = {
      disable-scroll = true;
      all-outputs = false;
      format = "<span style=\"italic\">{}</span>";
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = " ";
        deactivated = " ";
      };
    };

    tray = {
      icon-size = 21;
      spacing = 10;
    };

    clock = {
      format = "{:%Y-%m-%d %H:%M:%S}";
      interval = 5;
      tooltip = false;
      calendar = {
        mode = "year";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          days = "<span color='#ecc6d9'><b>{}</b></span>";
          weeks = "<span color='#99ffdd'><b>W{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-click-forward = "tz_up";
        on-click-backward = "tz_down";
        on-scroll-up = "shift_up";
        on-scroll-down = "shift_down";
      };
    };

    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      # format-good = "", # An empty format will hide the module
      # format-full = "";
      format-icons = [" " " " " " " " " "];
    };

    network = {
      format-wifi = "{essid} ({signalStrength}%)  ";
      format-ethernet = "{ifname}: {ipaddr}/{cidr}  ";
      format-disconnected = "Disconnected ⚠";
      "interval"  = 7;
    };

    pulseaudio = {
      #scroll-step = 1;
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-muted = "";
      format-icons = {
        headphones = " ";
        handsfree = "";
        headset = "";
        phone = " ";
        portable = " ";
        car = " ";
        default = [" " " "];
      };
      on-click = "pavucontrol";
    };
  };

  style = ./waybar-style.css;
}
