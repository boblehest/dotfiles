{ pkgs, config, ... }:

{
  programs.rofi.enable = true;

  services = {
    redshift = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 3500;
        night = 3000;
      };
    };
  };

  home.packages = with pkgs; [
    firefox
    networkmanagerapplet
    openconnect
    pavucontrol
    spotify
    unclutter-xfixes 
    zathura 
  ];
}
