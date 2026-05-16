{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    battery_monitor = {
      url = "gitlab:boblehest/battery-monitor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, battery_monitor, disko, ... }:
  let
    specialArgs = { inherit battery_monitor home-manager nixos-hardware; };
    mkHost = { hardware, host, system ? "x86_64-linux" }:
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          { nixpkgs.overlays = [ battery_monitor.overlays.default ]; }
          disko.nixosModules.disko
          hardware
          ./modules/default.nix
          ./system
          host
        ];
      };
  in {
    nixosConfigurations = {
      jlo-zrch   = mkHost { hardware = ./hardware/lenovo-t14s.nix; host = ./hosts/jlo-zrch; };
      jlo-laptop = mkHost { hardware = ./hardware/lenovo-t490.nix; host = ./hosts/jlo-laptop; };
      bilbo      = mkHost { hardware = ./hardware/bilbo.nix;       host = ./hosts/bilbo; };
      frodo      = mkHost { hardware = ./hardware/frodo.nix;       host = ./hosts/frodo; };
    };
  };
}
