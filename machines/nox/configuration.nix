{ pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
  dirs = {
    defaults = ../../defaults;
    colorschemes = ../../colorschemes;
  };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
  };
  configs = {
    fish = import (dirs.defaults + /fish) { inherit pkgs; };
    ssh = import (dirs.defaults + /ssh);
    kakoune = import (dirs.defaults + /kakoune) { inherit pkgs; };
    git = import (dirs.defaults + /git);
    sway = import (dirs.defaults + /sway) { inherit pkgs; };
    kitty = import (dirs.defaults + /kitty);
    firefox = import (dirs.defaults + /firefox) { inherit pkgs; };
    gpg = import (dirs.defaults + /gpg);
    gtk = import (dirs.defaults + /gtk) { inherit pkgs; };
    fzf = import (dirs.defaults + /fzf);
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      "${home-manager}/nixos"
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # fix the infinite locking loop
  boot.kernelParams = [ "button.lid_init_state=open" ];

  networking = {
    # nameservers = [ "127.0.0.1" "::1" ];
    # resolvconf.useLocalResolver = true;
    hostName = "nox"; # Define your hostname.
    networkmanager = {
      enable = true;
    };
    # networkmanager.dns = "none";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
    hosts = import (dirs.defaults + /hosts);
  };

  # DNS over TLS
  # services.dnscrypt-proxy2 = {
  #   enable = true;
  #     settings = {
  #     ipv6_servers = true;
  #     require_dnssec = true;

  #     sources.public-resolvers = {
  #       urls = [
  #         "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
  #         "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  #       ];
  #       cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
  #       minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
  #     };

  #     # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
  #     # server_names = [ ... ];
  #   };
  # };

  # systemd.services.dnscrypt-proxy2.serviceConfig = {
  #   StateDirectory = "dnscrypt-proxy2";
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "dvp";
  # };

  # Enable the X11 windowing system.
  # services.xserver = {
  #   enable = true;
  #   videoDrivers = [ "nvidia" ];
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce = {
  #       enable = true;
  #       noDesktop = true;
  #       enableXfwm = false;
  #     };
  #   };
  #   windowManager.i3 = {
  #     enable = true;
  #     package = pkgs.i3-gaps;
  #   };
  #   displayManager = {
  #     lightdm.enable = true;
  #     defaultSession = "xfce+i3";
  #   };
  #   # Enable touchpad support (enabled default in most desktopManager).
  #   libinput = {
  #     enable = true;
  #     touchpad.naturalScrolling = true;
  #   };
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # enable opengl
  # hardware.opengl = {
  #   enable = true;
  #   package = pkgs.mesa.drivers;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  hardware.openrazer.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # hardware.nvidiaOptimus.disable = true;

  services.udev = {
    extraHwdb = ''
      evdev:input:b0003v1532p026F*
       KEYBOARD_KEY_700e2=leftmeta
       KEYBOARD_KEY_700e3=leftalt
       KEYBOARD_KEY_700e6=rightmeta
    '';
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "docker" "networkmanager" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nvidia-offload
    brightnessctl
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    font-awesome
  ];

  programs.qt5ct.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # wayland+Sway support
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # List services that you want to enable:

  # enable xdg portals and pipewire for screensharing
  services.pipewire.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  home-manager.users.michael = { pkgs, ... }: {
    programs.home-manager.enable = true;

    # fish shell
    programs.fish = {
      enable = true;
    } // configs.fish;

    programs.gh = {
      enable = true;
      editor = "kak";
      gitProtocol = "ssh";
    };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "michael";
    home.homeDirectory = "/home/michael";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.05";

    programs.exa.enable = true;
    programs.command-not-found.enable = true;

    home.packages = with pkgs; [
      tree
      curl
      neofetch
      docker-compose
      docker-sync
      dnsutils
      traceroute
      nmap
      ipcalc
      discord
      slack
      stow
      jetbrains-mono
      xdg-utils
      swaylock
      swayidle
      wl-clipboard
      grim
      slurp
      wf-recorder
      wdisplays
      wofi
      chromium
      file
      aspell
      aspellDicts.en
      git-crypt
      subsurface
      ripgrep
      imv
      # unstable.helix
    ];

    home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";

    programs.ssh = {
      enable = true;
    } // configs.ssh;

    programs.kakoune = {
      enable = true;
    } // configs.kakoune;

    xdg.configFile."kak/colors/grv.kak".source = (dirs.colorschemes + /kakoune/grv.kak);

    programs.git = {
      enable = true;
    } // configs.git;

    programs.waybar = {
      enable = true;
    };
    # taking manual control of the waybar config since nix tells me the config
    # is wrong
    xdg.configFile."waybar/config".source = (dirs.defaults + /waybar/config.json);
    xdg.configFile."waybar/style.css".source = (dirs.defaults + /waybar/style.css);

    wayland.windowManager.sway = {
      enable = true;
    } // configs.sway;

    programs.kitty = {
      enable = true;
    } // configs.kitty;

    programs.firefox = {
      enable = true;
    } // configs.firefox;

    services.gpg-agent = {
      enable = true;
    } // configs.gpg;

    gtk = {
      enable = true;
    } // configs.gtk;

    programs.fzf = {
      enable = true;
    } // configs.fzf;

    nixpkgs.config = {
      allowUnfree = true;
      chromium.enableWideVine = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  # system.autoUpgrade.enable = true;
}

