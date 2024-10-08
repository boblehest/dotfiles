{ pkgs, lib, ... }:

with pkgs;
with {
  inherit (lib) id;
  inherit (lib.strings) lowerChars upperChars;
  zipToAttrs =
    list1: list2:
    lib.listToAttrs (lib.zipListsWith (name: value: { inherit name value; }) list1 list2);
};

{
  programs = {
    fzf = { # fuzzy finder
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = true;
      enableZshIntegration = false;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
    };

    tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind-key -n M-j swap-window -t -1\; select-window -t -1
        bind-key -n M-\; swap-window -t +1\; select-window -t +1
        set-option -sa terminal-features ',xterm-termite:RGB'
        set-option -g status-position top
      '';
    };

    zellij = { # terminal multiplexer
      enable = false;
      enableFishIntegration = true;
      # TODO Create a custom layout (the default one is probably meant only to
      # get introduced to the features. I think its UI elements take up too
      # much space. Make a more "slim"/minimal layout.
      settings = {
        session_serialization = false; # TODO I still see new files being created in .cache/zellij after setting this to false
        pane_frames = false;
        copy_on_select = false; # TODO How do I copy text with this set to false?
        auto_layout = false; # TODO This appears to have had no effect. Layout still happens automatically when I create new panes
        ui.pane_frames.hide_session_name = true;
        keybinds = let directions = {
          Left = "j";
          Down = "k";
          Up = "l";
          Right = ";";
        };
        charUpperMap = zipToAttrs lowerChars upperChars;
        shiftMap = charUpperMap // {
          ";" = ":";
        };
        mod = {
          none = lib.id;
          alt = (d: "Alt ${d}");
          ctrl = (d: "Ctrl ${d}");
          shift = (d: lib.getAttr d shiftMap);
        };
        unbindH = mod: { unbind = mod "h"; };
        bindDir_ = mod: cmd: arg: dir: key: {
          name = "bind \"${mod key}\"";
          value = { "${cmd}" = arg dir; };
        };
        bindDir = mod: cmd: arg: (lib.mapAttrs' (bindDir_ mod cmd arg) directions) // (unbindH mod);
        in rec {
          resize =
            (bindDir mod.none "Resize" (d: "Increase ${d}")) //
            (bindDir mod.shift "Resize" (d: "Decrease ${d}"));
          pane = bindDir mod.none "MoveFocus" id;
          move = bindDir mod.none "MovePane" id;
          "shared_except \"locked\"" = (bindDir mod.alt "MoveFocusOrTab" id) // {
            unbind = mod.ctrl "o"; # TODO See if the config generator merges unbind correctly.
          };
          tab = {
            "bind \"${directions.Left}\"" = { GoToPreviousTab = []; };
            "bind \"${directions.Right}\"" = { GoToNextTab = []; };
          } // (unbindH mod.none);
          scroll = {
            "bind \"${directions.Down}\"" = { ScrollDown = []; };
            "bind \"${directions.Up}\"" = { ScrollUp = []; };
            "bind \"${directions.Left}\"" = { PageScrollDown = []; };
            "bind \"${directions.Right}\"" = { PageScrollUp = []; };
          } // (unbindH mod.none);
          search = scroll;
        };
      };
    };

    lf = { # file browser
      enable = true;
      keybindings = {
        "j" = "updir";
        "k" = "down";
        "l" = "up";
        ";" = "open";
        "h" = "find-next";
        "<delete>" = "delete";
      };
      commands = {
        open = "&${pkgs.mimeo}/bin/mimeo \"$f\"";
      };
    };

    lazygit.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
