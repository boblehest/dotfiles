{ pkgs, config, ... }:

let
  cfg = import ../settings.nix;
in {
  i18n = { defaultLocale = "en_US.UTF-8"; };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Oslo";

  nix = {
    settings = {
      trusted-users = [ "root" "${cfg.username}" "@wheel" ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nixcache.reflex-frp.org"
        "https://all-hies.cachix.org"
        "https://qfpl.cachix.org"
        "https://cache.iog.io"
      ];
      trusted-public-keys = [
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
        "qfpl.cachix.org-1:JTTxGW07zLPAGglHlMbMC3kQpCd6eFRgbtnuorCogYw="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ]; 
    };
  };

  systemd.services."before-home-manager-${cfg.username}" = {
    script = "mkdir -p /nix/var/nix/profiles/per-user/${cfg.username}";
    path = [ pkgs.coreutils ];
    before = [ "home-manager-${cfg.username}.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  nixpkgs = {
    config = { allowUnfree = true; };
  };

  location.provider = "geoclue2";

  networking = {
    networkmanager.enable = true;
    hostName = cfg.hostName;
    firewall.enable = false;
    dhcpcd.denyInterfaces = [ "wlp0s20f3" ];
    bridges.br0.interfaces = [ "enp0s20f0u11u4" ];
  };

  environment.systemPackages = with pkgs; [
    acpi
    binutils
    coreutils
    curl
    exa
    fd
    lf 
    ripgrep
    tokei
    unzip
    wget
    xclip
    xorg.xkill
    zip
  ];

  system.stateVersion = cfg.stateVersion;
}
