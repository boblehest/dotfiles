{ pkgs, ... }:

{
  home.packages = with pkgs; [ youtube-dl ];

  programs.mpv = {
    enable = true;
  };
}
