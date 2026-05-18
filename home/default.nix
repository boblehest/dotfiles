{ lib, myFeatures, homeStateVersion, ... }:

{
  home.stateVersion = homeStateVersion;

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
