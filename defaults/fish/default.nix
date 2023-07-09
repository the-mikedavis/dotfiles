{ pkgs }:
{
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
  interactiveShellInit = ''
    if [ (uname -n) = "rabbit.mango2" ]
        source ~/.asdf/asdf.fish
    end
  '';
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
