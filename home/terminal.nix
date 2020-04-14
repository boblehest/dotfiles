{ pkgs, ... }:

with pkgs;
with import ../lib;

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

    tmux = {
      enable = true;
      escapeTime = 0;
    };
  };

  home.activation.installLfConfig = execute ''
      mkdir -p ~/.config/lf
      ln -sf /etc/nixos/dotfiles/home/lf/lfrc ~/.config/lf/
    '';
}
