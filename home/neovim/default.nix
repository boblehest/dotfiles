{ config, pkgs, lib, ... }:

with import <home-manager/modules/lib/dag.nix> { inherit lib; };

let
  execute = cmd:
  dagEntryAfter [ "installPackages" ] ''
  ${cmd}
  '';
in
  {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      viAlias = false;
      vimAlias = false;
      withNodeJs = false;
      withPython = false;
      withPython3 = true;
      withRuby = false;
      plugins = with pkgs.vimPlugins; [
        vim-repeat
        vim-abolish
        vim-commentary
        vim-fugitive
        vim-surround
        vim-unimpaired
        fzfWrapper
        fzf-vim
        vim-lion
        coc-nvim
        vimtex
        vim-polyglot
        vim-glsl
        vim-markdown
      ];
    };

  home.activation.neovim = execute ''
    ln -sfT /etc/nixos/dotfiles/home/neovim/config ~/.config/nvim/
  '';
}
