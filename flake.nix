{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    battery_monitor = {
      url = "gitlab:boblehest/battery-monitor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secretCfg-src = {
      type = "path";
      path = "/etc/nixos/dotfiles/settings.nix";
    };
    hardwareConfiguration-src = {
      type = "path";
      path = "/etc/nixos/hardware-configuration.nix";
    };
  };

  outputs = { nixpkgs, home-manager, secretCfg-src, hardwareConfiguration-src, battery_monitor, ... }: let
    hardwareConfiguration = import hardwareConfiguration-src;
    secretCfg = import secretCfg-src;
    specialArgs = { inherit secretCfg battery_monitor;};
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;
      modules = [
        {
          nixpkgs.overlays = [ battery_monitor.overlays.default ];
        }
        hardwareConfiguration
        ./system
        ./modules/vpn.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${secretCfg.username}" = import ./home;
        }
      ];
    };
  };
}
