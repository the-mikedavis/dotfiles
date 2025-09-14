# Home-manager configuration for a macbook
{ pkgs, ... }:

let
  dirs = {
    defaults = ../defaults;
    colorschemes = ../colorschemes;
    overlays = ../overlays;
  };

  configs = {
    fish = import (dirs.defaults + /fish) { inherit pkgs; };
    git = import (dirs.defaults + /git) { inherit pkgs; } "mbp";
    sway = import (dirs.defaults + /sway) { inherit pkgs; };
    kitty = import (dirs.defaults + /kitty);
    firefox = import (dirs.defaults + /firefox) { inherit pkgs; };
    fzf = import (dirs.defaults + /fzf);
    lazygit = import (dirs.defaults + /lazygit);
  };
in
{
  home.stateVersion = "22.05";

  # fish shell
  programs.fish = {
    enable = true;
    package = pkgs.fish;
  } // configs.fish;

  programs.gh = {
    enable = true;
    settings = {
      editor = "hx";
      git_protocol = "ssh";
    };
  };

  home.packages = with pkgs; [
    tree
    curl
    neofetch
    jetbrains-mono
    file
    git-crypt
    ripgrep
    bat
    killall
    nixfmt-rfc-style
    nix-prefetch-github
    fd
    # tree-sitter
    fastmod
    hexyl
    # cachix
    # docker-compose
    asciinema
    cloc
    eza
    gnupg
    direnv
    podman
    qemu
  ];

  programs.ssh = {
    enable = true;
    # TODO: move this into the ssh config dir.
    enableDefaultConfig = false;
  };

  programs.git = {
    package = pkgs.git;
    enable = true;
  } // configs.git;

  xdg.configFile."helix/config.toml".source = (dirs.defaults + /helix/config.toml);
  xdg.configFile."helix/themes/grv.toml".source = (dirs.colorschemes + /helix/grv.toml);
  xdg.configFile."tree-sitter/config.json".source = (dirs.defaults + /tree-sitter/config.json);
  xdg.configFile."kitty/dark-theme.auto.conf".source = (dirs.colorschemes + /kitty/grv.conf);
  # Commented out and created manually while I figure out a light theme.
  # xdg.configFile."kitty/light-theme.auto.conf".source = (dirs.colorschemes + /kitty/grv_light.conf);
  xdg.configFile."kitty/no-preference-theme.auto.conf".source = (dirs.colorschemes + /kitty/grv.conf);

  programs.kitty = {
    enable = true;
  } // configs.kitty;

  programs.fzf = {
    enable = true;
  } // configs.fzf;

  programs.lazygit = {
    enable = true;
  } // configs.lazygit;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
