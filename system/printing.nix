{ config, lib, pkgs, ... }:
{
  options.my.features.printing = lib.mkEnableOption "printing (CUPS/avahi)";

  config = lib.mkIf config.my.features.printing {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
  };
}
