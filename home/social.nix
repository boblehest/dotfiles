{ pkgs, lib, ... }:

let
  cfg = import ../settings.nix;
  discord = pkgs.discord.override rec {
    version = "0.0.17";
    src = builtins.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "058k0cmbm4y572jqw83bayb2zzl2fw2aaz0zj1gvg6sxblp76qil";
    };
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
