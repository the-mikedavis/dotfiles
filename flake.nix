{
  description = "@the-mikedavis' machine configurations";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence/master";

    kak-buffercraft.url = "github:the-mikedavis/buffercraft.kak/v0.0.1";
  };

  outputs = inputs@{ nixpkgs, home-manager, impermanence, ... }:
    let
      system = "x86_64-linux";
      nixconfig = {
        nixpkgs.config = {
          allowUnfree = true;
          chromium.enableWideVine = true;
        };
      };

      pkgs-unstable = import inputs.unstable { config.allowUnfree = true; system = system; };
      common-modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.michael = import ./home.nix;
        }
        impermanence.nixosModules.impermanence
        {
          environment.systemPackages = [
            pkgs-unstable._1password-gui
            pkgs-unstable.discord
            inputs.kak-buffercraft.defaultPackage.${system}
          ];
        }
        ./modules/common.nix
      ];
    in
    {
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
