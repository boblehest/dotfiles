{ pkgs, ... }:

{
  # TODO All this should probably be in the config for a specific host/hardware. Not part of the general settings.
  # If we later spot commonalities, we can refactor.
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
