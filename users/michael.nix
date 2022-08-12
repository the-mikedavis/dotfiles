impermanence: { pkgs, ... }:
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
    git = import (dirs.defaults + /git);
    sway = import (dirs.defaults + /sway) { inherit pkgs; };
    kitty = import (dirs.defaults + /kitty);
    firefox = import (dirs.defaults + /firefox) { inherit pkgs; };
    gpg = import (dirs.defaults + /gpg);
    gtk = import (dirs.defaults + /gtk) { inherit pkgs; };
    fzf = import (dirs.defaults + /fzf);
    lazygit = import (dirs.defaults + /lazygit);
  };

  github-notifications-token = (import (dirs.defaults + /tokens)).github-notifications;
in
{
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

  home.packages = with pkgs; [
    tree
    curl
    neofetch
    dnsutils
    traceroute
    nmap
    ipcalc
    slack
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
    bat
    killall
    _1password
    nixfmt
    nix-prefetch-github
    clipman
    gnome3.adwaita-icon-theme
    unstable._1password-gui
    edge.discord
    unstable.spotify
    unstable.element-desktop
    unstable.wireshark
    unstable.wezterm
    fd
    tree-sitter
    fastmod
    hexyl
    cachix
    docker-compose
    asciinema
    erlangR25
    (unstable.rebar3.overrideAttrs (prev: { buildInputs = [ erlangR25 ]; }))
    cloc
    unstable.audacity
    unstable.zoom-us
    unstable.exa
    unstable.linuxPackages-libre.perf
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
    package = pkgs.unstable.git;
    enable = true;
  } // configs.git;

  programs.waybar = {
    enable = true;
  };
  # taking manual control of the waybar config since nix tells me the config
  # is wrong
  xdg.configFile."waybar/config".source = (dirs.defaults + /waybar/config.json);
  xdg.configFile."waybar/style.css".source = (dirs.defaults + /waybar/style.css);
  xdg.configFile."waybar/github.sh".source = pkgs.writeShellScript "github.sh" ''
    count=`${pkgs.curl}/bin/curl --no-progress-meter -u the-mikedavis:${github-notifications-token} https://api.github.com/notifications | ${pkgs.jq}/bin/jq '. | length'`
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
  '';
  # wofi styling and config
  xdg.configFile."wofi/config".source = (dirs.defaults + /wofi/config);
  xdg.configFile."wofi/style.css".source = (dirs.defaults + /wofi/style.css);

  xdg.configFile."helix/config.toml".source = (dirs.defaults + /helix/config.toml);
  xdg.configFile."helix/themes/grv.toml".source = (dirs.colorschemes + /helix/grv.toml);

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

  xdg.configFile."tree-sitter/config.json".source = (dirs.defaults + /tree-sitter/config.json);

  ## Persistence config.
  # The root file-system is a tmpfs: volatile memory that is
  # wiped on reboot. So we need to explicitly declare what to persist across
  # reboots. These files/directories are mounted from non-volatile memory.
  # In modules/common.nix we declare the system-level persisted directories.
  home.persistence."/nix/persist/home/michael" = {
    directories = [
      # Misc docs.
      "Documents"
      # == Top-level dots ==
      # Source code. This is essentially a cache since everything is a git repo.
      "src"
      # GPG keys and metadata.
      ".gnupg"
      # SSH keys and config.
      ".ssh"
      # hex.pm caches, downloaded library tarballs, auth etc.
      ".hex"
      # Mix archives (Elixir)
      ".mix"
      # Firefox data, essentially a cache plus auth stuff.
      # ".firefox"
      ".mozilla"
      # cargo cache (Rust)
      ".cargo/registry"
      ".cargo/bin"
      ".cargo/git"
      # == Local state ==
      # Fish history and completions
      ".local/share/fish"
      # Podman cache
      ".local/share/containers"
      # Repl history and trusted settings
      ".local/share/nix"
      # Z (fish jump util) database
      ".local/share/z"
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
    ];
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
  } // configs.sway;

  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
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

  programs.lazygit = {
    enable = true;
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
}
