{ config, pkgs, lib, fetchFromGitHub, ... }:

with {
  inherit (pkgs.vimUtils) buildVimPlugin;
  sources = (import ../../nix/sources.nix);
};

let
  extraVimPlugins = map (name: buildVimPlugin {
    inherit name;
    src = sources.${name};
  }) [
    "telescope-ui-select.nvim" # make vim use telescope when prompting the user to make a choice
    "vim-monochrome" # colorscheme
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
      asyncomplete-vim
      asyncomplete-lsp-vim
      coc-texlab
      everforest # color scheme
      nvim-lspconfig # helper for configuring the LSP client for probably all languages I use
      plenary-nvim # dependency of telescope-nvim
      telescope-nvim # fuzzy finder
      trouble-nvim # shows diagnostics/errors with telescope
      vim-abolish
      vim-fugitive # git commands
      vim-polyglot
      vim-qf
      vim-repeat
      vim-sleuth
      nvim-surround
      vim-unimpaired
      which-key-nvim
    ] ++ extraVimPlugins;
    extraLuaConfig = lib.strings.fileContents ./config/init.lua;
  };

  home.packages = [
    pkgs.texlab
  ];
}
