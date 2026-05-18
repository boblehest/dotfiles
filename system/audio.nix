{ config, lib, ... }:
{
  options.my.features.audio = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ "user" "system" ]);
    default = null;
    description = ''
      PipeWire audio mode.
        "user"   — user-session PipeWire (desktops)
        "system" — system-wide PipeWire (servers with audio services)
        null     — audio disabled
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (config.my.features.audio == "user") {
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };
    })
    (lib.mkIf (config.my.features.audio == "system") {
      services.pipewire = {
        enable = true;
        systemWide = true;
        pulse.enable = true;
      };
    })
  ];
}
