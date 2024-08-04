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
  };

  outputs = { nixpkgs, home-manager, battery_monitor, ... }: let
    # TODO Make this into module options instead
    secretCfg = {
      username = "jlo";
      conserveMemory = false;
      hostName = "jlo-laptop";
      laptopFeatures = true;
      workFeatures = false;
      latex = true;
      intelVideo = true;
      stateVersion = "23.11";
      nvidia = false;
      oldIntel = false;
      swapCapsEscape = true;
      git = {
        enable = true;
        userName = "Jørn Lode";
        userEmail = "jlode90@gmail.com";
      };
    };
    specialArgs = { inherit secretCfg battery_monitor; };
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;
      modules = [
        {
          nixpkgs.overlays = [ battery_monitor.overlays.default ];
        }
        ./hardware/lenovo-t490.nix
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
