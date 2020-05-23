{ pkgs, ... }:

{
  home.packages = with pkgs; [
    audacity 
    filezilla
    flameshot
    gimp
    jmtpfs
    transmission-gtk
    youtube-dl
  ];

  programs.mpv = {
    enable = true;
  };
}
