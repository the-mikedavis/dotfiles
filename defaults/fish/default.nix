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
  interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
  '';
}
