{ pkgs, lib, config, ... }:

let
  cfg = import ../settings.nix;
in
  {
    # TODO Why does home-manager have its own stateVersion, and why is it not
    # equal to the other stateVersion?
    home.stateVersion = "18.09";

    imports = [
      ./common.nix
      ./desktop
      ./fish
      ./neovim
      ./other.nix
      ./terminal.nix
    ] ++ lib.optional cfg.latex ./latex.nix;
  }
