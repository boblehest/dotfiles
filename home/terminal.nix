{ pkgs, lib, ... }:

with pkgs;
with import ../lib/execute.nix { inherit lib pkgs; };

{
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = true;
      enableZshIntegration = false;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
    };

    alacritty = {
      enable = true;
      settings.font.size = 16;
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
        set-option -sa terminal-features ',xterm-termite:RGB'
      '';
    };

    lf = {
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

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
