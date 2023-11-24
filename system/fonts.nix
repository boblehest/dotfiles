{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      hack-font
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
  };
}
