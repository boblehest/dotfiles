{ lib, config, secretCfg, battery_monitor, ... }:

  {
    # TODO Why does home-manager have its own stateVersion, and why is it not
    # equal to the other stateVersion?
    home.stateVersion = "18.09";

    imports = [
      battery_monitor.homeManagerModules.default
      ./common.nix
      ./desktop
      ./fish
      ./neovim
      ./other.nix
      ./terminal.nix
    ] ++ lib.optional secretCfg.latex ./latex.nix;
  }
