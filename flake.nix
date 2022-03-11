{
  description = "@the-mikedavis' machine configurations";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    bleeding-edge.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence/master";
  };

  outputs = inputs@{ nixpkgs, home-manager, impermanence, ... }:
    let
      system = "x86_64-linux";

      pkgs-unstable = import inputs.unstable { config.allowUnfree = true; system = system; };
      pkgs-edge = import inputs.bleeding-edge { config.allowUnfree = true; system = system; };

      nixconfig = {
        nixpkgs = {
          config = {
            allowUnfree = true;
            chromium.enableWideVine = true;
          };
          overlays = [
            (import ./overlays)
            (_final: _prev: {
              unstable = pkgs-unstable;
              edge = pkgs-edge;
            })
          ];
        };
      };

      common-modules = [
        # add flakes support
        {
          nix = {
            package = pkgs-edge.nix;
            extraOptions = ''
              experimental-features = nix-command flakes
            '';
            trustedUsers = [ "root" "michael" ];
          };
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.michael = import ./home.nix;
        }
        impermanence.nixosModules.impermanence
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
