{ pkgs, lib, ... }:

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

    home.sessionVariables.EDITOR = "nvim";

    programs = {
      git = {
        enable = true;
        package = pkgs.gitMinimal;
        aliases = {
          st = "status -s";
          co = "checkout";
        };
        extraConfig = {
          init.defaultBranch = "master";
          pull.rebase = false;
        };
      };
      mpv.enable = true;
    };
  }
