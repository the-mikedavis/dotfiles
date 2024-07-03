{
  description = "Darwin home configuration for the work laptop.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, home-manager, ... }:
    {
      homeConfigurations = {
        "michaeld2" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./home.nix
            {
              home = {
                # yes, like r2d2.
                username = "michaeld2";
                homeDirectory = "/Users/michaeld2";
                stateVersion = "22.05";
              };
            }
          ];
        };
      };
    };
}
