{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secretCfg-src = {
      flake = false;
      url = "path:/etc/nixos/dotfiles/settings.nix";
    };
    hardwareConfiguration-src = {
      flake = false;
      url = "path:/etc/nixos/hardware-configuration.nix";
    };
  };

  outputs = { nixpkgs, home-manager, secretCfg-src, hardwareConfiguration-src, ... }: let
    hardwareConfiguration = import hardwareConfiguration-src;
    secretCfg = import secretCfg-src;
    specialArgs = { inherit secretCfg; };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;
      modules = [
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
