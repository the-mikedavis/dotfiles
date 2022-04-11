{ pkgs, ... }:
let
  dirs = {
    defaults = ./defaults;
    colorschemes = ./colorschemes;
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

  github-notifications-token = (import (dirs.defaults + /tokens)).github-notifications;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fish shell
  programs.fish = {
    enable = true;
  } // configs.fish;

  programs.gh = {
    enable = true;
    settings = {
      editor = "kak";
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
    bat
    killall
    _1password
    nixfmt
    rust-analyzer
    nix-prefetch-github
    clipman
    gnome3.adwaita-icon-theme
    unstable._1password-gui
    unstable.discord
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
  ];

  home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";

  programs.qutebrowser.enable = true;

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

  xdg.configFile."rebar3/rebar.config".text = ''
    {plugins, [rebar3_hex]}.
  '';

  xdg.configFile."erlang_ls/erlang_ls.config".text = ''
    apps_dirs:
      - "_build/default/lib/*"
    include_dirs:
      - "_build/default/lib/*/include"
      - "include"
  '';

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

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

  programs.exa.enable = true;
  programs.lazygit.enable = true;

  # build an index of available packages within nixpkgs
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
