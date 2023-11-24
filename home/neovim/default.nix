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
    "asyncomplete-ultisnips.vim"
    "telescope-ui-select.nvim"
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
      asyncomplete-vim
      asyncomplete-lsp-vim
      fzf-vim
      fzfWrapper
      nord-vim
      nvim-lspconfig
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
    pkgs.haskell-language-server
    pkgs.texlab
  ];
}
