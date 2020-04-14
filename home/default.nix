{ pkgs, lib, config, ... }:

let
  cfg = import ../settings.nix;
in
  {
    imports = [
      ./common.nix
      ./desktop
      ./fish
      ./jetbrains.nix
      ./mpv.nix
      ./neovim
      ./social.nix
      ./terminal.nix
    ] ++ lib.optional cfg.latex ./latex.nix;
  }
