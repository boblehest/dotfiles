{ config, lib, pkgs, ... }:
{
  options.my.features.postgres = lib.mkEnableOption "PostgreSQL";

  config = lib.mkIf config.my.features.postgres {
    services.postgresql = {
      enable = true;
      settings.port = 5433;
      ensureDatabases = [ "mydatabase" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        host  all       all     127.0.0.1/32  trust
        host  all       all     ::1/128       trust
      '';
    };
  };
}
