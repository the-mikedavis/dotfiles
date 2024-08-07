impermanence:
{ pkgs, ... }:
{
  imports = [ impermanence ];

  programs.git = {
    enable = true;
    extraConfig.safe.directory = "*";
  };

  home.persistence."/nix/persist/home/root" = { };

  home.stateVersion = "21.05";
}
