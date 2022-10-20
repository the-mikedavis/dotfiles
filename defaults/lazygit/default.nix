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
        command = "gh pr checkout {{index .PromptResponses 0}}";
        context = "localBranches";
        loadingText = "Checking out PR...";
        description = "check out a pull request by number";
      }
      {
        key = "<c-p>";
        command = "git remote prune {{.SelectedRemote.Name}}";
        context = "remotes";
        loadingText = "Pruning...";
        description = "prune deleted remote branches";
      }
    ];
    os.editCommand = "hx";
    os.editCommandTemplate = "{{editor}} -- {{filename}}:{{line}}";
  };
}
