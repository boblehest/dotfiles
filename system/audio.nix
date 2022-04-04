{ pkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
