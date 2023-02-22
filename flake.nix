{
  description = "@the-mikedavis' machine configurations";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    bleeding-edge.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence/master";
  };

  outputs = inputs@{ nixpkgs, home-manager, impermanence, ... }:
    let
      system = "x86_64-linux";

      pkgs-unstable = import inputs.unstable { config.allowUnfree = true; system = system; };
      pkgs-edge = import inputs.bleeding-edge { config.allowUnfree = true; system = system; };

      home-manager-impermanence = impermanence + "/home-manager.nix";

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
            settings.trusted-users = [ "root" "michael" ];
          };
        }
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./users/root.nix home-manager-impermanence;
          home-manager.users.michael = import ./users/michael.nix home-manager-impermanence;
        }
        ./modules/common.nix
      ];
    in
    {
      nixosConfigurations = {
        mango = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixconfig
            ./machines/mango/configuration.nix
          ] ++ common-modules;
        };
        mango2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixconfig
            ./machines/mango2/configuration.nix
          ] ++ common-modules;
        };
      };
    };
}
