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
    trustedUsers = [ "root" "${cfg.username}" "@wheel" ];
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://qfpl.cachix.org"
      "https://nixcache.reflex-frp.org"
      "https://all-hies.cachix.org"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
      "qfpl.cachix.org-1:JTTxGW07zLPAGglHlMbMC3kQpCd6eFRgbtnuorCogYw="
    ]; 
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
  };

  environment.systemPackages = with pkgs; [
    acpi
    binutils
    coreutils
    curl
    exa
    fd
    gitMinimal
    lf 
    ripgrep
    rq
    termite 
    tokei
    unzip
    wget
    xclip
    xorg.xkill
    zip
  ];

  system.stateVersion = "19.09";
}