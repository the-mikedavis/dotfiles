{
  aliases = {
    git = "!exec git";
    g = "!exec git";
    t = "tag --sort=version:refname";
    sha = "rev-parse HEAD";
    st = "status";
    b = "branch";
    sw = "switch";
    ci = "commit";
    cia = "commit -a";
    co = "checkout";
    count = "rev-list --all --count";
    unstage = "reset HEAD --";
    ph = "push";
    pl = "pull";
    d = "difftool";
    f = "fetch";
    ff = "merge --ff-only";
    branch-name = "rev-parse --abbrev-ref HEAD";
    pub = "!git push -u origin $(git branch-name)";
    lt = "!git tag --sort=version:refname | tail -n 1";
    # Garbage-collect the repository to save on space and make git
    # snappier. Good for large repositories with many thousands of
    # commits.
    pack = "gc --aggressive --prune=now";
  };
  extraConfig = {
    core.editor = "hx";
    hub.protocol = "ssh";
    pull.rebase = "false";
    init.defaultBranch = "main";
    push.followTags = "true";
    push.default = "simple";
    tag.gpgSign = "true";
    commit.verbose = "true";
    # use difftastic as the difftool ('git dt')
    diff.tool = "difftastic";
    "difftool \"difftastic\"".cmd = "difft \"$LOCAL\" \"$REMOTE\"";
    difftool.prompt = false;
    pager.difftool = true;
  };
  ignores = [
    "*.swp"
    "*.swo"
    ".projections.json"
    "*.elixir_ls/"
    "nohup.out"
    "erlang_ls.config"
  ];
  userName = "Michael Davis";
  userEmail = "mcarsondavis@gmail.com";
  signing = {
    key = "25D3AFE4BA2A0C49";
    signByDefault = true;
  };
}
