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

    tmux = { # terminal multiplexer
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind-key j swap-window -t -1\; select-window -t -1
        bind-key \; swap-window -t +1\; select-window -t +1
        bind-key -n M-j select-window -t -1
        bind-key -n M-\; select-window -t +1
        set-option -sa terminal-features ',xterm-termite:RGB'
        set-option -g status-position top
      '';
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
