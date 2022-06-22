{
  description = "Darwin home configuration for the work laptop.";
  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager }: {
    homeConfigurations = {
      "michaeld2@michaeld2-a01.vmware.com" = home-manager.lib.homeManagerConfiguration {
        configuration = import ./home.nix;
        system = "aarch64-darwin";
        pkgs = import nixpkgs { system = "aarch64-darwin"; };
        homeDirectory = "/Users/michaeld2";
        # yes, like r2d2.
        username = "michaeld2";
        stateVersion = "22.05";
      };
    };
  };
}
