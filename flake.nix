{
  description = "@the-mikedavis' machine configurations";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, unstable, home-manager, agenix, ... }:
  let
    system = "x86_64-linux";
    nixconfig = { nixpkgs.config.allowUnfree = true; };
    pkgs-unstable = import unstable { config.allowUnfree = true; system = system; };
    common-modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.michael = import ./home.nix;
      }
      agenix.nixosModules.age
      {
        environment.systemPackages = [
          agenix.defaultPackage.${system}
          pkgs-unstable._1password-gui
        ];
      }
    ];
  in {
    nixosConfigurations = {
      mango = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          nixconfig
          ./machines/mango/configuration.nix
        ] ++ common-modules;
      };

      nox = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          nixconfig
          ./machines/nox/configuration.nix
        ] ++ common-modules;
      };
    };
  };
}
