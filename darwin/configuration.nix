{pkgs, ...}:

{
  system.stateVersion = 5;
  programs.fish.enable = true;
  users.users.michael = {
    home = "/Users/michael";
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = ["root" "michael"];
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.michael = import ./home.nix;
  # Use touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
