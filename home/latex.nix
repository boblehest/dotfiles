{ config, lib, pkgs, ... }:

{
  options.jlo.latex = lib.mkEnableOption {};

  config = lib.mkIf config.jlo.latex {
    programs.zathura = {
      options = {
        synctex = true;
        synctex-editor-command = "code -g %{input}:%{line}";
      };
    };

    home.packages = with pkgs; [ tectonic ];
  };
}
