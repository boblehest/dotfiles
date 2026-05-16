{ config, lib, pkgs, ... }:

{
  options.my.latex = lib.mkEnableOption {};

  config = lib.mkIf config.my.latex {
    programs.zathura = {
      options = {
        synctex = true;
        synctex-editor-command = "code -g %{input}:%{line}";
      };
    };

    home.packages = with pkgs; [ tectonic ];
  };
}
