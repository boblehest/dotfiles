{ pkgs, secretCfg, ... }:

{
  users.users."${secretCfg.username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
      "docker"
      "fuse"
      "plugdev"
      "dialout"
      "video" # so the user can change brightness under sway
    ];
    shell = pkgs.fish;
    initialHashedPassword = "";
  };
}
