{ config, pkgs, lib, fetchFromGitHub, ... }:

with {
  inherit (import ../../lib) execute;
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  sources = (import ../../nix/sources.nix);
};

let
  extraVimPlugins = map (name: buildVimPluginFrom2Nix {
    inherit name;
    src = sources.${name};
  }) [
    "asyncomplete-lsp.vim"
    "asyncomplete-ultisnips.vim"
    "vim-lsp-settings"
  ];
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
      asyncomplete-vim
      fzf-vim
      fzfWrapper
      nord-vim
      ultisnips
      vim-abolish
      vim-commentary
      vim-fugitive
      vim-glsl
      vim-lion
      vim-lsp
      vim-markdown
      vim-polyglot
      vim-repeat
      vim-sleuth
      vim-snippets
      vim-surround
      vimtex
      vim-unimpaired
    ] ++ extraVimPlugins;
    extraConfig = ''
      source ~/.config/nvim/init2.vim
    '';
  };

  home.activation.neovim = execute ''
      ln -sfT /etc/nixos/dotfiles/home/neovim/config/init.vim ~/.config/nvim/init2.vim
  '';

  home.packages = [
    pkgs.haskell-language-server
  ];
}
