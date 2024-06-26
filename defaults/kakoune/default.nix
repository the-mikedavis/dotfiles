{ pkgs }: {
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

    # plugins
    evaluate-commands %sh{
      plugins="$kak_config/plugins"
      mkdir -p "$plugins"
      [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
      printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
    }
    plug "andreyorst/plug.kak" noload
    plug "kak-lsp/kak-lsp" config %{
      # config here
      map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'

    }
  '';
}
