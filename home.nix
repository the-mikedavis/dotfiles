{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
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
}
