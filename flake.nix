{
  description = "My NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nix-flatpak.url = "github:gmodena/nix-flatpak/";
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, nix-flatpak, ... }: {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-flatpak.nixosModules.nix-flatpak

          ./hosts/thinkpad

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home/user/home.nix;
          }
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	        nix-flatpak.nixosModules.nix-flatpak

          ./hosts/desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            home-manager.users.user = {
              imports = [
                ./home/user/home.nix
                ./hosts/desktop/home.nix
                ./modules/plasma/home.nix
              ];
            };
          }
        ];
      };

      player = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	        nix-flatpak.nixosModules.nix-flatpak

          ./hosts/player

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home/user/home.nix;
          }
        ];
      };
    };
  };
}
