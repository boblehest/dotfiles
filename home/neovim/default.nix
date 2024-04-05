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
    "1989.vim" # colorscheme
    "asyncomplete-ultisnips.vim"
    "bubblegum" # colorscheme
    "caret.nvim" # colorscheme
    "github-colors" # colorscheme
    "rasmus.nvim" # colorscheme
    "telescope-ui-select.nvim"
    "vim-monochrome" # colorscheme
    "vim-pink-moon" # colorscheme
    "vim-vice" # colorscheme
    "vscode.nvim" # colorscheme
  ];
in
{
  # TODO Provide an overlay in which neovim contains all the basic plugins we
  # want, and then install it globally, with the goal that dev environments can
  # specify neovim + the relevant language servers, and then it will instantiate
  # neovim with our base plugins + whatever extra the dev environment adds.
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
      gruvbox # colorscheme
      Ionide-vim # language f#
      nord-vim # colorscheme
      nvim-lspconfig # I'm not sure if this does anything for us
      melange-nvim # colorscheme
      plenary-nvim
      telescope-nvim
      trouble-nvim
      ultisnips
      vim-abolish
      vim-commentary
      vim-fugitive
      vim-glsl # language glsl
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
    pkgs.texlab
  ];
}
