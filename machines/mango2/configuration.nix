{ pkgs, ... }:

let
  dirs = {
    defaults = ../../defaults;
  };
in
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "mango2";

    useDHCP = false;
    interfaces.enp67s0.useDHCP = true;
    # interfaces.wlp68s0f1u3.useDHCP = true;
    # Enable WiFi
    # networkmanager.enable = true;

    hosts = import (dirs.defaults + /hosts);
  };

  # Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_testing;

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65535";
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
