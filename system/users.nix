{ pkgs, ... }:

let
  username = (import ../settings.nix).username;
in {
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "fuse" "plugdev" "dialout" ];
    shell = pkgs.fish;
    initialHashedPassword = "";
  };

  home-manager.users."${username}" = { pkgs, ... }: {
    imports = [ ../home ];
  };
}
