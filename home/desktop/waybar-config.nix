{
  settings = {
    # -------------------------------------------------------------------------
    # Global configuration
    # -------------------------------------------------------------------------

    layer = "top";

    position = "top";

    modules-left = [
      "sway/workspaces"
      "sway/mode"
      "custom/media"
    ];
    modules-center = [
      "sway/window"
    ];
    modules-right = [
      "tray"
      "pulseaudio"
      "network"
      "cpu"
      "memory"
      "backlight"
      "battery"
      "battery#bat2"
      "clock"
      "custom/power"
    ];


    # -------------------------------------------------------------------------
    # Modules
    # -------------------------------------------------------------------------

    "sway/workspaces" = {
      disable-scroll = true;
      all-outputs = false;
      format = "{name}: {icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        high-priority-named = [ "1" "2" "3" "4" ];
        urgent = "";
        focused = "";
        default = "";
      };
    };

    "sway/mode" = {
      format = "<span style=\"italic\">{}</span>";
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      }
    };

    tray = {
      icon-size = 21;
      spacing = 10;
    };

    clock = {
      tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
      format-alt = "{:%Y-%m-%d}";
    };

    cpu = {
      format = "{usage}% ";
    };

    memory = {
      format = "{}% ";
    };

    backlight = {
      # device = "acpi_video1";
      format = "{percent}% {icon}";
      states = [0,50,75];
      format-icons = ["", "", ""];
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
      format-icons = ["", "", "", "", ""];
    };

    "battery#bat2" = { # TODO Why two batteries?
      bat = "BAT2";
    };

    network = {
      # "interface" = "wlp2s0", # (Optional) To force the use of this interface
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
      format-disconnected = "Disconnected ⚠";
      "interval"  = 7;
    };

    pulseaudio = {
      #scroll-step = 1;
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-muted = "";
      format-icons = {
        headphones = "";
        handsfree = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = ["", ""];
      };
      on-click = "pavucontrol";
    };

    "custom/power" = {
      format = "  ";
      interval = "once";
      on-click = "wlogout";
      tooltip = false;
    };
  };

  style = ./waybar-style.css;
  }
