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
      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
    };

    termite = {
      enable = true;
      audibleBell = false;
      clickableUrl = true;
      font = "Hack 13";
      scrollbackLines = 10000;
      browser = "${pkgs.xdg-utils}/bin/xdg-open";

      colorsExtra = ''
        background = #1e1e1e
        foreground = #ffffff
        color8  = #8DA691
        color1  = #8F423C
        color9  = #EEAA88
        color2  = #BB5050
        color10 = #CCC68D
        color3  = #F9D25B
        color11 = #EEDD99
        color4  = #FF9050
        color12 = #C9B957
        color5  = #709289
        color13 = #FFCBAB
        color6  = #D13516
        color14 = #C25431
        color7  = #EFE2E0
        color15 = #F9F1ED
      '';
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

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  home.activation.installLfConfig = execute ''
      mkdir -p ~/.config/lf
      ln -sf /etc/nixos/dotfiles/home/lf/lfrc ~/.config/lf/
    '';
}
