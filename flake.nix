{
  description = "@the-mikedavis' machine configurations";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence/master";
  };

  outputs =
    inputs@{
      nixos,
      darwin,
      nixpkgs,
      home-manager,
      impermanence,
      ...
    }: {
      nixosConfigurations = {
        mango2 = let
          system = "x86_64-linux";

          # TODO: remove these. Just use regular unstable.
          pkgs-unstable = import nixpkgs {
            config.allowUnfree = true;
            system = system;
          };
          pkgs-edge = import nixpkgs {
            config.allowUnfree = true;
            system = system;
          };

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
                settings.trusted-users = [
                  "root"
                  "michael"
                ];
                settings.experimental-features = "nix-command flakes";
                gc = {
                  automatic = true;
                  randomizedDelaySec = "15m";
                  # 1:15pm - this computer is usually off at the default 3:15am.
                  dates = "13:15";
                  options = "--delete-older-than 30d";
                };
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
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixconfig
            ./machines/mango2/configuration.nix
            # TODO: get rid of common-modules.
          ] ++ common-modules;
        };
      };
      darwinConfigurations = {
        # nix run nix-darwin/master#darwin-rebuild -- switch --flake .#ice1
        ice1 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
          ];
        };
      };
    };
}
