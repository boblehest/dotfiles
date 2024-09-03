{ battery_monitor, home-manager, config, lib, specialArgs, ... }:

let
  cfg = config.jlo;
  extendImports = attrs: attrs // { imports = attrs.imports ++ common-imports; };
  common-imports = [
    ./shikane.nix
    battery_monitor.homeManagerModules.default
  ];
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
    home-manager.users = lib.mapAttrs (_: value: inputs: extendImports (value.hm-config inputs)) cfg.users;
  };
}
