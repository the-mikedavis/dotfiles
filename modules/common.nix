{ pkgs, ... }:

let
  dirs = { defaults = ../defaults; };
  passwd = import (dirs.defaults + /passwd);
in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.fish.enable = true;

  # enable xdg portals and pipewire for screensharing in wayland
  services.pipewire.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      # Not sure this is necessary anymore after switching to a flake.
      "/etc/nixos"
      # WiFi connections. Probably not necessary since I don't have a WiFi card.
      # "/etc/NetworkManager/system-connections"
      # Root-level podman containers.
      "/var/lib/containers"
      # Persist system logs so we can read what happened in the event of an unexpected crash or hang.
      "/var/log"
      # Tailscale state files.
      "/var/lib/tailscale"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  users.mutableUsers = false;
  users.users.root.initialHashedPassword = passwd.root;
  users.users.michael = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "wireshark" "podman" ];
    initialHashedPassword = passwd.michael;
    subUidRanges = [ { count = 100000; startUid = 65536; } ];
    subGidRanges = [ { count = 100000; startGid = 65536; } ];
  };

  environment.systemPackages = with pkgs; [
    kakoune
    pavucontrol
    cryptsetup
    ncdu
    qt5.qtwayland
    qt5ct
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    apple-color-emoji
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    # make a `docker` alias for podman
    dockerCompat = true;
    extraPackages = with pkgs; [
      slirp4netns
      fuse-overlayfs
    ];
  };

  # sway/wayland
  programs.sway.enable = true;

  # Allow other users like `root` to access directories bind-mounted
  # by impermanence's home-manager integration.
  programs.fuse.userAllowOther = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.unstable.wireshark;
  };

  environment.variables.EDITOR = "hx";

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
