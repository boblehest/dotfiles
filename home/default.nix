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
      # ./jetbrains.nix
      ./neovim
      ./other.nix
      ./social.nix
      ./terminal.nix
    ] ++ lib.optional cfg.latex ./latex.nix;
  }
