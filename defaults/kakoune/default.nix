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

    # make x extend the selection down, X extend up
    def -params 1 extend-line-down %{
      exec "<a-:>%arg{1}X"
    }

    def -params 1 extend-line-up %{
      exec "<a-:><a-;>%arg{1}K<a-;>"
      try %{
        exec -draft ';<a-K>\n<ret>'
        exec X
      }
      exec '<a-;><a-X>'
    }
  '';
}
