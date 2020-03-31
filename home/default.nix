{ pkgs, lib, config, ... }:

{
  imports = [
    ./common.nix
    ./desktop
    ./fish
    ./jetbrains.nix
    ./latex.nix
    ./mpv.nix
    ./neovim
    ./programming.nix
    ./social.nix
    ./terminal.nix
  ];
}
