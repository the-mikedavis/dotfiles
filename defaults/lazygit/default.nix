{
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
        command = "gh pr checkout {{index .PromptResponses 0}} --branch {{index .PromptResponses 0}}";
        context = "localBranches";
        loadingText = "Checking out PR...";
        description = "check out a pull request by number";
      }
      # Prune remote branches (delete branches that have been deleted on the remote).
      {
        key = "<c-p>";
        command = "git remote prune {{.SelectedRemote.Name}}";
        context = "remotes";
        loadingText = "Pruning...";
        description = "prune deleted remote branches";
      }
      # Uses git-absorb to create fixup commits that automatically target the right commit.
      # Use 'S' from the commits context to apply the fixup commits.
      {
        key = "<c-a>";
        command = "git absorb";
        context = "files";
        loadingText = "Absorbing...";
        description = "absorb staged changes into fixup commits";
      }
    ];
    os.editPreset = "helix";
    # Prevent lazygit from performing fetches on startup. This behavior can
    # get in your way if you use git+ssh for remotes and password-protect
    # your SSH keys.
    git.autoFetch = false;
  };
}
