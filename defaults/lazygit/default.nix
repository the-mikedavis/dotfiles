{
  settings = {
    promptToReturnFromSubprocess = false;
    keybinding = {
      universal.toggleRangeSelect = "V";
      commits = {
        cherryPickCopy = "c";
        pasteCommits = "v";
      };
    };
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
    os.editPreset = "helix (hx)";
    # Prevent lazygit from performing fetches on startup. This behavior can
    # get in your way if you use git+ssh for remotes and password-protect
    # your SSH keys.
    git.autoFetch = false;
  };
}
