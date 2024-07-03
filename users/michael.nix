impermanence:
{ pkgs, ... }:
let
  dirs = {
    defaults = ../defaults;
    colorschemes = ../colorschemes;
    overlays = ../overlays;
  };

  configs = {
    fish = import (dirs.defaults + /fish) { inherit pkgs; };
    ssh = import (dirs.defaults + /ssh);
    kakoune = import (dirs.defaults + /kakoune) { inherit pkgs; };
    git = import (dirs.defaults + /git) { inherit pkgs; } "mango2";
    sway = import (dirs.defaults + /sway) { inherit pkgs; };
    kitty = import (dirs.defaults + /kitty);
    firefox = import (dirs.defaults + /firefox) { inherit pkgs; };
    gpg = import (dirs.defaults + /gpg);
    gtk = import (dirs.defaults + /gtk) { inherit pkgs; };
    fzf = import (dirs.defaults + /fzf);
    lazygit = import (dirs.defaults + /lazygit);
  };
in {
  imports = [ impermanence ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fish shell
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
  } // configs.fish;

  programs.gh = {
    enable = true;
    settings = {
      editor = "hx";
      git_protocol = "ssh";
    };
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

  # TODO: use a module to declare per-user packages with `stdenv.isLinux`/`stdenv.isDarwin`
  # to control linux vs. macos packages.
  home.packages = with pkgs; [
    tree
    curl
    # Hello r/unixporn.
    neofetch
    # ?
    dnsutils
    traceroute
    # All your ports are mine.
    nmap
    # Community Slacks.
    slack
    # Font.
    jetbrains-mono
    # xdg-open and friends.
    xdg-utils
    # Lockscreen for wayland.
    swaylock
    # Clipboard for Wayland.
    wl-clipboard
    # Screenshot taker for Wayland.
    grim
    # Geometry recorder for Wayland.
    slurp
    # Video recorder for Wayland.
    wf-recorder
    # ?
    wdisplays
    # Swaybar but fancy.
    wofi
    # Works well on Wayland for running Spotify but Firefox is nicer for real
    # browsing.
    chromium
    # Show me file details.
    file
    # Unused since I switched from Kakoune:
    # aspell
    # aspellDicts.en
    # Hide stuff in this repository.
    git-crypt
    # Workspace-wide grep.
    ripgrep
    # Image viewer that works well with Wayland/Sway.
    imv
    # Go get SHAs for github repos.
    nix-prefetch-github
    # M-Z for clipboard history. Wiped on reboot because of impermanence. Should be
    # moved into the sway config by absolute path in the future.
    clipman
    # ? I don't remember. Better icons / GTK theme?
    gnome3.adwaita-icon-theme
    # Occasionally useful for managing vaults. The web UI is more useful though.
    unstable._1password-gui
    # Using edge here since new Discord updates sometimes need an update _right now_
    # or else you're not allowed to use it.
    edge.discord
    unstable.spotify
    # Matrix client.
    unstable.element-desktop
    # Alternate terminal.
    unstable.wezterm
    # Find but better CLI args? Not convinced on this one yet.
    fd
    # Workspace-wide search/replace via regex. Basically `codemod`.
    fastmod
    # Hex viewer. Pipes into `less` nicely.
    hexyl
    # Fast flake downloads.
    cachix
    # NOTE: should be replaced with podman-compose if possible.
    docker-compose
    # Recordings for Helix.
    asciinema
    # cloc but with a fun cost-of-development metric.
    scc
    # Occasionally useful for recordings (commented out most of the time):
    # unstable.audacity
    unstable.eza
    unstable.linuxPackages-libre.perf
    # Nix language server.
    unstable.nil
    # System monitor / colorful `top`.
    btop
    # Find typos.
    typos
    # Nice GUI for perf.data, creates flamegraphs without having to mess with perl.
    hotspot
    # Bazel is not good on NixOS. Put it in a container.
    distrobox
    # Faster and more automatic auto-squash.
    git-absorb
    unstable.beeper
    unzip
    nixfmt-rfc-style
  ];

  home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";

  programs.ssh = { enable = true; } // configs.ssh;

  programs.kakoune = { enable = true; } // configs.kakoune;

  xdg.configFile."kak/colors/grv.kak".source =
    (dirs.colorschemes + /kakoune/grv.kak);

  programs.git = {
    package = pkgs.unstable.git;
    enable = true;
  } // configs.git;

  programs.waybar = { enable = true; };
  # taking manual control of the waybar config since nix tells me the config
  # is wrong
  xdg.configFile."waybar/config".source = (dirs.defaults + /waybar/config.json);
  xdg.configFile."waybar/style.css".source =
    (dirs.defaults + /waybar/style.css);
  # wofi styling and config
  xdg.configFile."wofi/config".source = (dirs.defaults + /wofi/config);
  xdg.configFile."wofi/style.css".source = (dirs.defaults + /wofi/style.css);

  xdg.configFile."helix/config.toml".source =
    (dirs.defaults + /helix/config.toml);
  xdg.configFile."helix/themes/grv.toml".source =
    (dirs.colorschemes + /helix/grv.toml);
  xdg.configFile."helix/languages.toml".text = # toml
    ''
      [[language]]
      name = "erlang"
      rulers = [80]
    '';
  xdg.configFile."helix/ignore".text = # git-ignore
    ''
      !.github
    '';

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

  xdg.configFile."tree-sitter/config.json".source =
    (dirs.defaults + /tree-sitter/config.json);

  xdg.configFile."containers/storage.conf".text = # toml
    ''
      [storage]
      driver = "overlay"
      graphroot = "/nix/persist/var/lib/michael/containers"
    '';

  ## Persistence config.
  # The root file-system is a tmpfs: volatile memory that is
  # wiped on reboot. So we need to explicitly declare what to persist across
  # reboots. These files/directories are mounted from non-volatile memory.
  # In modules/common.nix we declare the system-level persisted directories.
  home.persistence."/nix/persist/home/michael" = {
    directories = [
      # GPG keys and metadata.
      ".gnupg"
      # SSH keys and config.
      ".ssh"
      # Firefox data, essentially a cache plus auth stuff.
      ".mozilla"
      # Fish history and completions
      ".local/share/fish"
      # nix profile and any other data Nix wants to store there.
      ".local/state/nix"
    ] ++ (builtins.map (d: {
      directory = d;
      method = "symlink";
    }) [
      # Misc docs.
      "Documents"
      # == Top-level dots ==
      # Source code. This is essentially a cache since everything is a git repo.
      "src"
      # hex.pm caches, downloaded library tarballs, auth etc.
      ".hex"
      # Mix archives (Elixir)
      ".mix"
      # ASDF version manager
      # I use Nix to install erlang/elixir/rebar3 on the host machine.
      # This is just to cache the asdf builds and configuration for my
      # work distrobox.
      ".asdf"
      # cargo cache (Rust)
      ".cargo/registry"
      ".cargo/bin"
      ".cargo/git"
      # kubectl
      ".kube"
      # == Local state ==
      # Podman cache
      # ".local/share/containers"
      # Repl history and trusted settings
      ".local/share/nix"
      # zoxide directory database
      ".local/share/zoxide"
      # direnv allowlist
      ".local/share/direnv"
      # == Config ==
      # Most apps in this category abuse the config dir to store state.
      ".config/Slack"
      ".config/discord"
      ".config/chromium"
      ".config/Element"
      ".config/spotify"
      ".config/1Password"
      ".config/gcloud"
      # == Cache ==
      ".cache/nix"
      ".cache/mozilla"
      ".cache/chromium"
      ".cache/yarn"
      ".cache/spotify"
      ".cache/mix"
      ".cache/nix-index"
      ".cache/erlang_ls"
      ".cache/rebar3"
      ".cache/fontconfig"
      ".cache/erlang-history"
      ".cache/gleam"
      ".cache/bazel"
    ]);
    files = [
      # Lazygit repository history
      # ".config/lazygit/state.yml"
      # Fish universal variables
      ".config/fish/fish_variables"
      # Auth config for Hex.pm (Erlang)
      ".config/rebar3/hex.config"
      # Nix cache config
      ".config/nix/nix.conf"
      # Cachix auth
      ".config/cachix/cachix.dhall"
      # GitHub CLI auth
      ".config/gh/hosts.yml"
      # Asciinema installation ID that links to your account
      ".config/asciinema/install-id"
      # wofi (picker) history
      ".cache/wofi-drun"
      ".cache/wofi-dmenu"
      # asdf global versions
      ".tool-versions"
    ];
    # > allows other users, such as `root`, to access files through the bind
    # > mounted directories listed in `directories`.
    allowOther = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "application/x-bzpdf" = "firefox.desktop";
      "application/x-gzpdf" = "firefox.desktop";
      "application/x-xzpdf" = "firefox.desktop";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.unstable.sway;
  } // configs.sway;

  # Notifications daemon
  # adapted from <https://github.com/archseer/snowflake/blob/352fbbe1fe30d717b0d16eba4c13cd86d42aca34/profiles/graphical/sway/default.nix#L82-L104>
  services.mako = {
    enable = true;
    anchor = "top-left";
    font = "JetBrains Mono 11";
    padding = "15,20";
    backgroundColor = "#282828F0";
    textColor = "#ebdbb2";
    borderSize = 2;
    borderColor = "#504945";
    defaultTimeout = 10000;
    markup = true;
    format = "<b>%s</b>\\n\\n%b";
  };

  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
  } // configs.kitty;

  programs.firefox = { enable = true; } // configs.firefox;

  services.gpg-agent = { enable = true; } // configs.gpg;

  gtk = { enable = true; } // configs.gtk;

  programs.fzf = { enable = true; } // configs.fzf;

  programs.lazygit = {
    enable = true;
    package = pkgs.unstable.lazygit;
  } // configs.lazygit;

  # build an index of available packages within nixpkgs
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
