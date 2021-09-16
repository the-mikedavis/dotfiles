{ pkgs, ... }:

let
  dirs = {
    defaults = ../../defaults;
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  # fix the infinite locking loop
  boot.kernelParams = [ "button.lid_init_state=open" ];

  networking = {
    hostName = "nox";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
    hosts = import (dirs.defaults + /hosts);
  };

  hardware.openrazer.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.udev = {
    extraHwdb = ''
      evdev:input:b0003v1532p026F*
       KEYBOARD_KEY_700e2=leftmeta
       KEYBOARD_KEY_700e3=leftalt
       KEYBOARD_KEY_700e6=rightmeta
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

