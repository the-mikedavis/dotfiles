{
  description = "Darwin home configuration for the work laptop.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs @ { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      nixpkgsConfig = {
        config.allowUnfree = true;
      };
    in {
      darwinConfigurations."MY674L9XP7" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs self; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.michaeld2 = import ./home.nix;
          }
        ];
      };
    };
}
