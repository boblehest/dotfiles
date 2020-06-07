{ config, pkgs, lib, ... }:

with import ../../lib;

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
      coc-nvim
      fzf-vim
      fzfWrapper
      nord-vim
      vim-abolish
      vim-commentary
      vim-fugitive
      vim-glsl
      vim-lion
      vim-markdown
      vim-polyglot
      vim-repeat
      vim-sleuth
      vim-surround
      vimtex
      vim-unimpaired
    ];
    extraConfig = ''
      source ~/.config/nvim/init.vim
    '';
  };

  home.packages = with pkgs; [
    nodejs # Unfortunately, coc-nvim runs/crawls on this.
  ];

  home.activation.neovim = execute ''
      ln -sfT /etc/nixos/dotfiles/home/neovim/config ~/.config/nvim
  '';
}
