{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # for video conferencing
    obs-studio
    chromium # teams doesn't work correctly in firefox
  ];
}
