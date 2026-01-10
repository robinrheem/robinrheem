{
  description = "NixOS + Home Manager Flake";
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substitutors = [
      "https://cache.nixos.org/"
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
  let 
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      carnage = lib.nixosSystem {
        inherit system;
	modules = [
	  ./hosts/carnage/default.nix
	  # home-manager integrated into NixOS
	  home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages= true;
            home-manager.users.robin = import ./users/robin/home.nix;
	  }
        ];
      };
      morales = lib.nixosSystem {
        inherit system;
	modules = [
	  ./hosts/carnage/default.nix
	  # home-manager integrated into NixOS
	  home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages= true;
            home-manager.users.robin = import ./users/robin/home.nix;
	  }
        ];
      };
    };
    homeConfigurations = {
      "robin@carnage" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = [ ./users/robin/home.nix ];
      };
    };
  };
}
