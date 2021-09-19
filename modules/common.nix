{ pkgs, ... }:

{
  # add flakes support
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

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
    gtkUsePortal = true;
  };

  users.users.michael = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "wireshark" "docker" ];
  };

  environment.systemPackages = with pkgs; [
    kakoune
    pavucontrol
    cryptsetup
    ncdu
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    font-awesome
  ];

  programs.qt5ct.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  virtualisation.docker.enable = true;

  # sway/wayland
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.variables.EDITOR = "kak";
}
