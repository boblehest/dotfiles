{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      hack-font
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
  };
}
