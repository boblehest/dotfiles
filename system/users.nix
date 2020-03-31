{ pkgs, ... }:

let
  username = (import ../settings.nix).username;
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "fuse" ];
    shell = pkgs.fish;
    initialHashedPassword = "";
  };

  home-manager.users."${username}" = { pkgs, ... }: {
    imports = [ ../home ];
  };
}
