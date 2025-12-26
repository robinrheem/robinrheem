{
  description = "NixOS + Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let 
    system = "x86_64-linux";
  in {
    nixosConfigurations.carnage = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/carnage/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages= true;
          home-manager.users.robin = import ./home/robin.nix;
        }
      ];
    };
  };
}
