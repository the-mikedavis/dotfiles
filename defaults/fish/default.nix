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
    nfic = "git clone git@github.com:NFIBrokerage/$argv";
    latestcommitmessage = "git log -1 --format=%s";
    next_tag = ''
    set -l current_tag_match (git tag --sort=version:refname | tail -n 1 | string match -r 'v(\d+)')
    set -l current_version_number (echo $current_tag_match[2])
    set -l next_version_number (echo $current_version_number + 1 | bc)
    git tag -s -a "v$next_version_number" -m $argv
    '';
  };
  shellAliases = {
    c = "cd";
    e = "exa";
    g = "git";
    dc = "docker-compose";
  };
}
