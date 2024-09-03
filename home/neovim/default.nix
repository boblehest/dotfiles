{ config, pkgs, lib, ... }:

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
      asyncomplete-lsp-vim
      asyncomplete-vim
      coc-texlab
      everforest # color scheme
      nvim-lspconfig # helper for configuring the LSP client for probably all languages I use
      nvim-surround # commands to easily add/remove/change delimiters around text objects (quotes, braces, html tags, ...) 
      nvim-treesitter
      # nvim-treesitter-textobjects # We might want stuff like this: https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-swap
      plenary-nvim # dependency of telescope-nvim
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # make vim use telescope when prompting the user to make a choice
      trouble-nvim # shows diagnostics/errors with telescope
      undotree
      vim-abolish # smarter substitute command + other features I never used
      vim-better-whitespace # highlight trailing whitespace
      vim-fugitive # git commands
      # vim-lion # commands for aligning blocks
      vim-polyglot # basic editor support lots of languages
      vim-qf
      vim-repeat # adds repeatability (with `.`) for some commands which are not supported out of the box
      vim-sleuth # automatically detects shiftwidth/expandtab based on file contents
      vim-unimpaired # just custom keybindings for some commands? Not sure what keybinds I use anymore
      which-key-nvim # tooltip to show available keybindings (pops up while typing a multi-key command)
    ];
    extraLuaConfig = lib.strings.fileContents ./config/init.lua;
  };

  home.packages = [
    pkgs.texlab
  ];
}
