{ ... }:
{
  programs.git = {
    enable = true;
    extraConfig.safe.directory = "*";
  };
}
