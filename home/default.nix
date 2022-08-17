{ pkgs, lib, config, ... }:

let
  cfg = import ../settings.nix;
in
  {
    home.stateVersion = "18.09";

    imports = [
      ./common.nix
      ./desktop
      ./fish
      # ./jetbrains.nix
      ./neovim
      ./other.nix
      ./social.nix
      ./terminal.nix
    ] ++ lib.optional cfg.latex ./latex.nix;
  }
