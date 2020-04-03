{ pkgs, lib, config, ... }:

{
  imports = [
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
