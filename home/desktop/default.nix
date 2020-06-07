{ pkgs, config, ... }:

{
  programs = {
    rofi.enable = true;
    feh = {
      enable = true;
      keybindings = {
        save_filelist = null;
        toggle_fullscreen = "f";
      };
    };
  };

  services = {
    redshift = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 3500;
        night = 3000;
      };
    };

    unclutter.enable = true;
  };

  home.packages = with pkgs; [
    dunst
    firefox
    networkmanagerapplet
    pavucontrol
    spotify
    zathura 
  ];
}
