{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
  ];

  home.file.".ideavimrc".text = ''
    set surround
    set hlsearch
    set incsearch
    set ignorecase
    set smartcase
    set incsearch
    set showmode
    set number
    set relativenumber

    let mapleader = "\"
  '';
}
