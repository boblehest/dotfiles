# Command line tools, terminals etc
{ pkgs, ... }:

with pkgs;

{
  programs = {
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
    };
  };
  home.packages = [
    exa
    fd
    lf 
    ripgrep
    rq
    termite 
    tokei
    xclip
    xorg.xkill
  ];
}
