{ ... }:

{
  nixpkgs.config = import ./nixpkgs-config.nix;
  # The previous setting is just for home-manager. The next line is to also
  # apply it for the user (e.g. when running nix-shell)
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
}
