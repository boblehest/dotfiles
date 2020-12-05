{ config, pkgs, lib, fetchFromGitHub, ... }:

with {
  inherit (import ../../lib) execute;
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
};

let
  asyncomplete-lsp-vim = buildVimPluginFrom2Nix {
    pname = "asyncomplete-lsp-vim";
    version = "2020-06-27";
    src = pkgs.fetchFromGitHub {
      owner = "prabirshrestha";
      repo = "asyncomplete-lsp.vim";
      rev = "684c34453db9dcbed5dbf4769aaa6521530a23e0";
      sha256 = "0vqx0d6iks7c0liplh3x8vgvffpljfs1j3g2yap7as6wyvq621rq";
    };
    meta.homepage = "https://github.com/prabirshrestha/asyncomplete-lsp.vim/";
  };

  vim-lsp-settings = buildVimPluginFrom2Nix {
    pname = "vim-lsp-settings";
    version = "2020-11-18";
    src = pkgs.fetchFromGitHub {
      owner = "mattn";
      repo = "vim-lsp-settings";
      rev = "753322a2c9fd8c2d3f0b96e40480a672aaab648e";
      sha256 = "1zafap3q978fgcq71pmrdkilaymaxk7hzdrr4ryqpwyibzi7359y";
    };
    meta.homepage = "https://github.com/mattn/vim-lsp-settings/";
  };
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
      vim-lsp
      asyncomplete-vim
      asyncomplete-lsp-vim
      fzf-vim
      fzfWrapper
      nord-vim
      vim-abolish
      vim-commentary
      vim-fugitive
      vim-glsl
      vim-lion
      vim-lsp-settings
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

  home.activation.neovim = execute ''
      ln -sfT /etc/nixos/dotfiles/home/neovim/config ~/.config/nvim
  '';

  home.packages = [
    pkgs.haskell-language-server
  ];
}
