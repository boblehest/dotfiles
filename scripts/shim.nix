{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./dotfiles/system
    ];
}
