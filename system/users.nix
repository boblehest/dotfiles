{ pkgs, secretCfg, ... }:

{
  users.users."${secretCfg.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "fuse" "plugdev" "dialout" "video" ]; # `video` so the user can change brightness under sway
    shell = pkgs.fish;
    initialHashedPassword = "";
  };
}
