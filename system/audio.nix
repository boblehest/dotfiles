{ config, lib, ... }:
{
  options.my.features.audio = lib.mkEnableOption "audio (PipeWire)";

  config = lib.mkIf config.my.features.audio {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
