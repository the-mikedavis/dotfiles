{ pkgs }:
{
  config = {
    colorScheme = "grv";
    indentWidth = 2;
    numberLines.enable = true;
    wrapLines.enable = true;
    ui.assistant = "cat";
  };
  extraConfig = ''
    # tune down the start-up info thingy
    set-option global startup_info_version 20210923
  '';
}
