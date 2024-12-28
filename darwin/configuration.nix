{pkgs, ...}:

{
  system.stateVersion = 5;
  services.nix-daemon.enable = true;
  programs.fish.enable = true;
  users.users.michaeld2 = {
    home = "/Users/michaeld2";
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = ["root" "michaeld2"];
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
