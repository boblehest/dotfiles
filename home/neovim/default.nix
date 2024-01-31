{ config, pkgs, lib, fetchFromGitHub, ... }:

with {
  inherit (import ../../lib/execute.nix { inherit lib pkgs; }) execute;
  inherit (pkgs.vimUtils) buildVimPlugin;
  sources = (import ../../nix/sources.nix);
};

let
  extraVimPlugins = map (name: buildVimPlugin {
    inherit name;
    src = sources.${name};
  }) [
    "1989.vim"
    "asyncomplete-ultisnips.vim"
    "bubblegum"
    "caret.nvim"
    "github-colors"
    "rasmus.nvim"
    "telescope-ui-select.nvim"
    "vim-monochrome"
    "vim-pink-moon"
    "vim-vice"
    "vscode.nvim"
  ];
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = false;
    vimAlias = false;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;
    plugins = with pkgs.vimPlugins; [
      agda-vim
      asyncomplete-vim
      asyncomplete-lsp-vim
      coc-texlab
      everforest # color scheme
      fzf-vim
      fzfWrapper
      gruvbox # colorscheme
      nord-vim # colorscheme
      nvim-lspconfig
      melange-nvim # colorscheme
      plenary-nvim
      telescope-nvim
      trouble-nvim
      ultisnips
      vim-abolish
      vim-commentary
      vim-fugitive
      vim-glsl
      vim-lion
      vim-lsp
      vim-markdown
      vim-polyglot
      vim-qf
      vim-repeat
      vim-sleuth
      vim-snippets
      vim-surround
      vim-unimpaired
      vimtex # TODO remove
      which-key-nvim
    ] ++ extraVimPlugins;
    extraConfig = ''
      source ~/.config/nvim/init2.vim

      lua << EOF
        ${lib.strings.fileContents ./config/init.lua}
      EOF
    '';
  };

  home.activation.neovim = execute ''
      ln -sfT /etc/nixos/dotfiles/home/neovim/config/init.vim ~/.config/nvim/init2.vim
  '';

  home.packages = [
    pkgs.texlab
  ];
}
