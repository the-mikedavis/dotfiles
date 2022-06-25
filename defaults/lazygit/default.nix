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
        loadingText = "Checking out PR";
      }
    ];
    os.editCommand = "hx";
    os.editCommandTemplate = "{{editor}} -- {{filename}}:{{line}}";
  };
}
