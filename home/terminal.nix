# Command line tools, terminals etc
{ pkgs, ... }:

with pkgs;

{
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
    };
    tmux = {
      enable = true;
      escapeTime = 0;
    };
  };
}
