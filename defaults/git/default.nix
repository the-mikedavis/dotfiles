{ pkgs }: machine:
let
  ssh-key-id = if machine == "mango2" then
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7lG1J2TQNaqJLKqAzTQQ8yHBArm4o9k/eeaYLSrDuo" else
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFEzKO2ZpSVWnLzdz+i3vROwdS/bPrrs9QItJO/6yTL";
  identity = if machine == "mango2" then "michael@mango" else "michaeld2@michaeld2L9XP7.vmware.com";
  allowed_signers = pkgs.writeText "allowed_signers" ''
    ${identity} ${ssh-key-id}
  '';
in {
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
    push.default = "simple";
    commit.verbose = "true";
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "${allowed_signers}";
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
    "/worktrees/"
  ];
  userName = "Michael Davis";
  userEmail = "mcarsondavis@gmail.com";
  signing = {
    key = ssh-key-id;
    signByDefault = true;
  };
}
