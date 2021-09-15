{ pkgs, ... }:

let
  dirs = {
    defaults = ../../defaults;
  };
  configs = {
    dnscrypt-proxy2 = import (dirs.defaults + /dnscrypt-proxy2);
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  networking = {
    hostName = "mango";

    useDHCP = false;
    interfaces.eno2.useDHCP = true;
    interfaces.wlo1.useDHCP = true;

    nameservers = [ "127.0.0.1" "::1" ];
    hosts = import (dirs.defaults + /hosts);
  };

  services.dnscrypt-proxy2 = configs.dnscrypt-proxy2;

  home-manager.users.michael = { pkgs, ... }: {
    programs.home-manager.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
