impermanence: { pkgs, ... }:
{
  imports = [ impermanence ];

  programs.git = {
    enable = true;
    extraConfig.safe.directory = "*";
  };

  home.persistence."/nix/persist/home/root" = {
    files = [
      # trusted settings in nix like `nix-command` and `flakes`
      ".local/share/nix/trusted-settings.json"
    ];
  };
}
