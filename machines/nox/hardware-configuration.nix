{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/409B-C246";
      fsType = "vfat";
    };

  boot.initrd.luks.devices.main = {
    name = "main";
    device = "/dev/disk/by-uuid/c67107b3-8b76-4457-8cc9-22b322f7e13c";
    preLVM = true;
    allowDiscards = true;
  };

  fileSystems."/nix" =
    { device = "/dev/vg/root";
      fsType = "ext4";
    };

  swapDevices = [
    { device = "/dev/vg/swap"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
