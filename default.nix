{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    hack-font
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jlo-nixos"; # TODO Make part of per-workstation config
  networking.networkmanager.enable = true;

  # networking.useDHCP = false;
  # networking.interfaces.enp4s0.useDHCP = true;
  # networking.interfaces.wlp2s0.useDHCP = true;

  time.timeZone = "Europe/Oslo";

  environment.systemPackages = with pkgs; [
    wget neovim networkmanagerapplet firefox termite lf unclutter-xfixes zathura gitMinimal
  ];

  networking.firewall.enable = false;

  programs.fish.enable = true;

  services.redshift = {
    enable = true;
    temperature = {
      day = 3500;
      night = 3000;
    };
  };

  location = {
    latitude = 60.4;
    longitude = 5.32;
  };

  users.users.jlo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
    initialHashedPassword = "";
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status
        i3lock
        i3blocks
      ];
    };
    xkbVariant = "altgr-intl";
    # TODO laptop only
    libinput.enable = true;
    xkbOptions = "caps:swapescape";
  };

  nix = {
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

  systemd.services."before-home-manager-jlo" = {
    script = "mkdir -p /nix/var/nix/profiles/per-user/jlo";
    path = [ pkgs.coreutils ];
    before = [ "home-manager-jlo.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

