{ lib, myFeatures, ... }:

{
  # TODO: Why does home-manager have its own stateVersion, and why is it not
  # equal to the other stateVersion?
  home.stateVersion = "25.05";

  imports = lib.optional myFeatures.desktop ./desktop
    ++ [
      ./fish
      ./latex.nix
      ./neovim
      ./nix.nix
      ./other.nix
      ./terminal.nix
    ];
}
