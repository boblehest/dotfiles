{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      l = "exa -lagFT --git-ignore --git --level 1";
      ls = "exa -a --git-ignore";
      tree = "exa --tree --git-ignore";
    };
  };
}
