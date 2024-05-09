{ pkgs, secretCfg, ... }:

{
  users.users."${secretCfg.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "fuse" "plugdev" "dialout" ];
    shell = pkgs.fish;
    initialHashedPassword = "";
  };
}
