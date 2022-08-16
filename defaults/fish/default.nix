{ pkgs }:
{
  plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
        sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
      };
    }
  ];
  functions = {
    latestcommitmessage = "git log -1 --format=%s";
    "," = ''
      nix run "nixpkgs#$argv[1]" -- $argv[2..-1]
    '';
    fish_right_prompt = ''
      ${pkgs.any-nix-shell}/bin/nix-shell-info
      printf " "

      set_color $fish_color_autosuggestion 2> /dev/null; or set_color 255
      date "+%H:%M:%S"
      set_color normal
    '';
    ghc = ''
      git clone "git@github.com:$argv[1]"
    '';
  };
  shellAliases = {
    c = "cd";
    e = "exa";
    l = "exa --long --all --links --git";
    g = "git";
    dc = "docker-compose";
    lg = "lazygit";
    nd = "nix develop --command fish";
    ch = "check";
    ts = "tree-sitter";
    pr = "gh pr checkout";
  };
}
