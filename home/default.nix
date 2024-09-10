{ lib, config, battery_monitor, ... }:

{
  # TODO Why does home-manager have its own stateVersion, and why is it not
  # equal to the other stateVersion?
  home.stateVersion = "18.09";

  imports = [
    ./desktop
    ./fish
    ./latex.nix
    ./neovim
    ./nix.nix
    ./other.nix
    ./terminal.nix
  ];
}
