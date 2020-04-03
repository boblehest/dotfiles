{ pkgs, lib, config, ... }:

{
  imports = [
    ./common.nix
    ./desktop
    ./fish
    ./jetbrains.nix
    #./latex.nix
    ./mpv.nix
    ./neovim
    ./social.nix
    ./terminal.nix
  ];
}
