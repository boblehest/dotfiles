{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
  discord = pkgs.discord.override rec {
    version = "0.0.26";
    src = builtins.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "MPdNxZJBmIN4NGEoYWvL2cmNm37/YT275m2bVWHXbwY=";
    };
    nss = pkgs.nss_latest;
  };
in
  {
    home.packages = with pkgs; [
      discord
      # weechat
    ] ++ lib.optionals cfg.workFeatures [
      slack
      teams
    ];
  }
