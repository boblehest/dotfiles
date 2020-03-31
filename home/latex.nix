{ pkgs, ... }:

{
  home.packages = with pkgs; [ zathura texlive.combined.scheme-full ];

  home.file.".latexmkrc".text = ''
    $pdf_previewer = 'start zathura';
  '';
}
