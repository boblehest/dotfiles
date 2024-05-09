{ pkgs, config, lib, secretCfg, ... }:

{
  i18n = { defaultLocale = "en_US.UTF-8"; };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Oslo";

  nix = {
    settings = {
      extra-experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "${secretCfg.username}" "@wheel" ];
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

  systemd.services."before-home-manager-${secretCfg.username}" = {
    script = "mkdir -p /nix/var/nix/profiles/per-user/${secretCfg.username}";
    path = [ pkgs.coreutils ];
    before = [ "home-manager-${secretCfg.username}.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  nixpkgs = {
    config = { allowUnfree = true; };
  };

  location.provider = "geoclue2";

  networking = {
    networkmanager = {
      enable = true;
    };
    hostName = secretCfg.hostName;
    firewall.enable = false;
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
  ];

  programs = {
    fish.enable = true;
    firejail.enable = true;
    dconf.enable = true;
  };

  system.stateVersion = secretCfg.stateVersion;
}
