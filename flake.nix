{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    battery_monitor = {
      url = "gitlab:boblehest/battery-monitor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, battery_monitor, ... }: let
    specialArgs = {
      inherit battery_monitor home-manager nixos-hardware;
    };
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
        ./modules/default.nix
        ./system
        {
          config.jlo.users.jlo = {
            hm-config = import ./home;
          };
          config.home-manager.users.jlo = {
            jlo = {
              latex = false;
              swapCapsEscape = true;
            };
            programs.jlo.git = {
              enable = true;
              userName = "Jørn Lode";
              userEmail = "jorn.lode@fakemail.no";
            };
          };
          config.jlo = {
            username = "jlo";
            hostName = "jlo-zrch";
            conserveMemory = false;
            videoDrivers = [ "intel" ];
            stateVersion = "25.05";
          };
        }
      ];
    };
  };
}
