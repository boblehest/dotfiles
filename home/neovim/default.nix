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
      everforest # color scheme
      nvim-lspconfig # helper for configuring the LSP client for probably all languages I use
      nvim-surround # commands to easily add/remove/change delimiters around text objects (quotes, braces, html tags, ...)
      nvim-treesitter
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.haskell
      nvim-treesitter-parsers.json
      # nvim-treesitter-parsers.latex
      nvim-treesitter-parsers.lua
      # nvim-treesitter-parsers.markdown
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.query # treesitter queries
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.vimdoc
      nvim-treesitter-parsers.xml
      nvim-treesitter-textobjects # We might want stuff like this: https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-swap
      plenary-nvim # dependency of telescope-nvim
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # make vim use telescope when prompting the user to make a choice
      # trouble-nvim # shows diagnostics/errors with telescope TODO Do we want this? Read the manual to see what it even does
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
    extraPackages = with pkgs; [
      texlab
      gcc # treesitter wants `cc` available

      # language servers
      # TODO I don't know if we want to put these here, since for e.g. haskell
      # we often want to use older versions of it (but will an older version of
      # the lsp softare always be compatible with the newer config here in
      # neovim? Probably not)
      rust-analyzer # rust
      rustfmt # rust
      haskell-language-server # haskell
      pyright # python
      ruff # python
      nixd # nix
      # TODO go, texlab
    ];
  };
}
