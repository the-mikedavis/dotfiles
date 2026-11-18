impermanence:
{ pkgs, ... }:
{
  imports = [ impermanence ];

  programs.git = {
    enable = true;
    settings.safe.directory = "*";
  };

  home.persistence."/nix/persist" = { };

  home.stateVersion = "21.05";
}
