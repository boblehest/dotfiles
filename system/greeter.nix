{ config, lib, pkgs, ... }:
{
  options.my.features.greeter = lib.mkEnableOption "login manager (greetd/tuigreet)";

  config = lib.mkIf config.my.features.greeter {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd sway
        '';
        user = "greeter";
      };
    };
  };
}
