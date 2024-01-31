{ pkgs, config, lib, ... }:

let
  cfg = import ../settings.nix;
  apRadio = "wlp0s20f3";
  # ethernetInterface = ...
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
        "https://ros.cachix.org"
      ];
      trusted-public-keys = [
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
        "qfpl.cachix.org-1:JTTxGW07zLPAGglHlMbMC3kQpCd6eFRgbtnuorCogYw="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
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
    networkmanager = {
      enable = true;
      unmanaged = lib.optionals config.services.hostapd.enable [
        apRadio # We manage this through hostapd -- NetworkManager please no touch
      ];
    };
    hostName = cfg.hostName;
    firewall.enable = false;
    interfaces.${apRadio}.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.12.1"; prefixLength = 24; }];
    dhcpcd.denyInterfaces = lib.optionals config.services.hostapd.enable [ apRadio ]; # TODO Not sure if this is necessary, because I'm not quite sure when a dhcp client would try to request an address. I assume it is _not_ necessary.
  };

  environment.systemPackages = with pkgs; [
    acpi
    binutils
    coreutils
    curl
    eza
    fd
    ripgrep
    tokei
    unzip
    wget
    xclip
    xorg.xkill
    zip
    zoom-us
  ];

  programs = {
    fish.enable = true;
    firejail.enable = true;
  };

  system.stateVersion = cfg.stateVersion;
}
