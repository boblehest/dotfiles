{ pkgs, config, lib, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Oslo";

  nix = {
    extraOptions = let
      giga = 1024 * 1024 * 1024;
    in ''
      min-free = ${toString (20 * giga)}
    '';

    settings = {
      extra-experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "${config.jlo.username}" "@wheel" ];
      substituters = [
        # "https://cache.nixos.org/" # TODO 2024-05-09 Does this one have to be added manually?
        "https://nixcache.reflex-frp.org"
        "https://qfpl.cachix.org"
        "https://cache.iog.io"
      ];
      trusted-public-keys = [
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "qfpl.cachix.org-1:JTTxGW07zLPAGglHlMbMC3kQpCd6eFRgbtnuorCogYw="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    flake = {
      setFlakeRegistry = false;
      setNixPath = false;
    };
  };
  location.provider = "geoclue2";

  networking = {
    networkmanager.enable = true;
    hostName = config.jlo.hostName;
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
    zip
    capitaine-cursors # TODO Put this along with the rest of the desktop config, if possible. Does just installing this also change the default cursor? I would think not.
  ];

  programs = {
    fish.enable = true;
    dconf.enable = true;
  };

  system.stateVersion = config.jlo.stateVersion; # Where to set this?
}
