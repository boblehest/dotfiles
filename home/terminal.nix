{ pkgs, lib, ... }:

with pkgs;
with import ../lib/execute.nix { inherit lib pkgs; };

{
  services.lorri.enable = true;

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = true;
      enableZshIntegration = false;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
    };

    alacritty.enable = true;
    tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';
    };
  };

  home.packages = [ direnv ];

  home.activation.installLfConfig = execute ''
      mkdir -p ~/.config/lf
      ln -sf /etc/nixos/dotfiles/home/lf/lfrc ~/.config/lf/
    '';
}
