{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-25.11";
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
          # NOTE the confusing similarity between the `jlo` config namespace
          # and the username `jlo`. They are semantically very different, even
          # though syntactically the same. Rename "jlo" to "heim".
          config.jlo.users.jlo = {
            hm-config = import ./home;
          };
          config.home-manager.users.jlo = {
            jlo = {
              latex = true;
              swapCapsEscape = true;
            };
            programs.jlo.git = {
              enable = true;
              userName = "Jørn Lode";
              userEmail = "jlode90@gmail.com";
            };
          };
          # config.services.jlo.grafana.enable = true;
          config.jlo = {
            username = "jlo"; # TODO Why is this an own option? It should be inferred from some attrset that configures all users
            # There rest of this is system-wide config, not user-config
            hostName = "jlo-laptop";
            ntfsDriver = true;
            conserveMemory = false;
            videoDrivers = [ "intel" ];
            stateVersion = "23.11";
          };
        }
      ];
    };
  };
}
