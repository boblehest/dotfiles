# Command line tools, terminals etc
{ pkgs, ... }:

with pkgs;

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
}
