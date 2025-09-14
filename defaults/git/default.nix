{ pkgs }:
machine:
let
  ssh-key-id =
    if machine == "mango2" then
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPW6mBMwoA+5f405+mGTs9s/hH6vRhsCmPaPJzARKtXd"
    else
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0cXT0qj1t/sRKhBcchbsZXM/gTIz8cCD/YO2SrrBkj";
  identity = if machine == "mango2" then "michael@mango2" else "michael@ice1.local";
  allowed_signers = pkgs.writeText "allowed_signers" ''
    ${identity} ${ssh-key-id}
  '';
in
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
    ph = "push";
    pl = "pull";
    d = "difftool";
    f = "fetch";
    ff = "merge --ff-only";
    # Garbage-collect the repository to save on space and make git
    # snappier. Good for large repositories with many thousands of
    # commits.
    pack = "gc --aggressive --prune=now";
  };
  extraConfig = {
    core.editor = "hx";
    hub.protocol = "ssh";
    fetch.prune = true;
    pull.rebase = "false";
    init.defaultBranch = "main";
    push.default = "simple";
    commit.verbose = "true";
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "${allowed_signers}";
    # use difftastic as the difftool ('git dt')
    diff.tool = "difftastic";
    "difftool \"difftastic\"".cmd = ''difft "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;
    pager.difftool = true;

    # <https://blog.gitbutler.com/how-git-core-devs-configure-git/>
    diff.algorithm = "histogram";
    diff.colorMoved = "plain";
    diff.mnemonicPrefix = true;
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
