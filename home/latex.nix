{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      synctex = true;
      synctex-editor-command = "code -g %{input}:%{line}";
    };
  };

  home.packages = with pkgs; [ tectonic ];
}
