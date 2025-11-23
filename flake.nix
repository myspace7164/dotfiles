{
  description = "my-nixos-flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/nixos-wsl";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      home-manager,
      nix-flatpak,
      nixos-wsl,
      ...
    }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs-unstable.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs-unstable.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style);
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        thinkpad = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
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

        desktop = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak

            ./hosts/desktop

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.user = import ./home/user/home.nix;
            }
          ];
        };

        player = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
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

        wsl = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-wsl.nixosModules.default

            ./hosts/wsl

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
