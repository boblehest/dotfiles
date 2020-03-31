{ config, pkgs, ... }:

let
  pypacks = python-packages: with python-packages; [ ipython requests ];
  python-with-packages = pkgs.python37.withPackages pypacks;
in {
  home.packages = with pkgs; [
    # Haskell
    # cabal-install
    # cabal2nix
    # ghcide.ghcide-ghc865
    # hlint
    # stack

    # Python
    python-with-packages
  ];
}
