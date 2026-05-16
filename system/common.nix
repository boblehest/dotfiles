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

    channel.enable = false;

    settings = {
      extra-experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "${config.my.username}" "@wheel" ];
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
      setFlakeRegistry = true;
      setNixPath = true;
    };
  };
  location.provider = "geoclue2";

  networking = {
    networkmanager.enable = true;
    hostName = config.my.hostName;
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
    awscli2 # Needed for work
  ];

  services = {
    fstrim.enable = true;
    upower.enable = true;
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
  };

  system.stateVersion = config.my.stateVersion; # Where to set this?
}
