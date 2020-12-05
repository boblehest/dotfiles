{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
  discord = pkgs.discord.override rec {
    version = "0.0.13";
    src = builtins.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0d5z6cbj9dg3hjw84pyg75f8dwdvi2mqxb9ic8dfqzk064ssiv7y";
    };
  };
in
  {
    home.packages = with pkgs; [
      discord
      weechat
    ] ++ lib.optionals cfg.workFeatures [
      slack
      teams
    ];
  }
