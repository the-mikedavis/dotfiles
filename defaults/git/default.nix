{
  aliases = {
    git = "!exec git";
    g = "!exec git";
    t = "tag --sort=version:refname";
    sha = "rev-parse HEAD";
    st = "status";
    b = "branch";
    ci = "commit";
    cia = "commit -a";
    co = "checkout";
    unstage = "reset HEAD --";
    ph = "push";
    pl = "pull";
    d = "diff";
    f = "fetch";
    branch-name = "rev-parse --abbrev-ref HEAD";
    pub = "!git push -u origin $(git branch-name)";
    lt = "!git tag --sort=version:refname | tail -n 1";
  };
  extraConfig = {
    core.editor = "kak";
    hub.protocol = "ssh";
    pull.rebase = "false";
    init.defaultBranch = "main";
    push.followTags = "true";
    push.default = "simple";
    tag.gpgSign = "true";
  };
  ignores = [
    "*.swp"
    "*.swo"
    ".projections.json"
    "*.elixir_ls/"
    "nohup.out"
  ];
  userName = "Michael Davis";
  userEmail = "mcarsondavis@gmail.com";
  signing = {
    key = "25D3AFE4BA2A0C49";
    signByDefault = true;
  };
}
