{ home-manager, config, lib, specialArgs, ... }:

let
  cfg = config.jlo;
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.jlo = {
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
    };
  };

  config = {
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = lib.mapAttrs (_: value: value.hm-config) cfg.users;
  };
}
