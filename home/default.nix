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
      ./neovim
      ./other.nix
      ./social.nix
      ./terminal.nix
    ] ++ lib.optional cfg.latex ./latex.nix;
  }
