{ pkgs, ... }:

{
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true; # TODO Why is this under audio
  };
  services.blueman.enable = true;
}
