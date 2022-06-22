# This is the configuration of a darwin machine
# (work-provided MacBook Pro, 2021 14-inch).
{ config, pkgs, ... }:

let
  dirs = {
    defaults = ../defaults;
    colorschemes = ../colorschemes;
    overlays = ../overlays;
  };

  configs = {
    fish = import (dirs.defaults + /fish) { inherit pkgs; };
    kakoune = import (dirs.defaults + /kakoune) { inherit pkgs; };
    git = import (dirs.defaults + /git);
    sway = import (dirs.defaults + /sway) { inherit pkgs; };
    kitty = import (dirs.defaults + /kitty);
    firefox = import (dirs.defaults + /firefox) { inherit pkgs; };
    fzf = import (dirs.defaults + /fzf);
  };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    aspell
    aspellDicts.en
    git-crypt
    ripgrep
    bat
    killall
    nixfmt
    nix-prefetch-github
    fd
    tree-sitter
    fastmod
    hexyl
    # cachix
    # docker-compose
    asciinema
    cloc
    exa
    gnupg
  ];

  home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";

  programs.ssh = {
    enable = true;
  };

  programs.git = {
    package = pkgs.git;
    enable = true;
  } // configs.git;

  xdg.configFile."helix/config.toml".source = (dirs.defaults + /helix/config.toml);
  xdg.configFile."helix/themes/grv.toml".source = (dirs.colorschemes + /helix/grv.toml);

  xdg.configFile."erlang_ls/erlang_ls.config".text = ''
    apps_dirs:
      - "_build/default/lib/*"
    include_dirs:
      - "_build/default/lib/*/include"
      - "include"
  '';

  xdg.configFile."tree-sitter/config.json".source = (dirs.defaults + /tree-sitter/config.json);

  programs.kitty = {
    enable = true;
  } // configs.kitty;

  programs.fzf = {
    enable = true;
  } // configs.fzf;

  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      customCommands = [
        # C-p checks out a pull request by number
        # https://github.com/jesseduffield/lazygit/wiki/Custom-Commands-Compendium#checkout-branch-via-github-pull-request-id
        {
          key = "<c-p>";
          prompts = [
            {
              type = "input";
              title = "PR #";
            }
          ];
          command = "gh pr checkout {{ index .PromptResponses 0 }}";
          context = "localBranches";
          loadingText = "Checking out PR";
        }
      ];
    };
  };
}
