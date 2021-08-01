{ pkgs }:
let
  kak-erlang = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/the-mikedavis/84859fa3d84a1b71a20b97b8a8ffa3f7/raw/dab74e661a54f0d480eefb89f9c0fb03d772c07b/erlang.kak";
    sha256 = "14ib67zhi2147wlrzvv3vq3b5f2abrghbqqjsnxp4h74fawl0f5w";
  };
in
{
  config = {
    autoReload = "yes";
    colorScheme = "grv";
    indentWidth = 2;
    numberLines.enable = true;
    wrapLines.enable = true;
    showWhitespace.enable = true;
    ui.assistant = "cat";
    hooks = [
      {
        name = "WinCreate";
        option = "[^*]*";
        commands = ''
          add-highlighter window/ column 81 default,rgb:404040
          add-highlighter global/ regex \h+$ 0:Error
        '';
      }
    ];
  };
  extraConfig = ''
    evaluate-commands %sh{
      plugins="$kak_config/plugins"
      mkdir -p "$plugins"
      [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
      printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
    }
    plug "andreyorst/plug.kak" noload

    alias global g git

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

    map global normal x ':extend-line-down %val{count}<ret>'
    map global normal X ':extend-line-up %val{count}<ret>'

    source ${kak-erlang}

    plug "occivink/kakoune-sudo-write"
    plug "delapouite/kakoune-buffers"
    plug "andreyorst/fzf.kak"

    # load fzf finding functions into the user mode (activated with space)
    hook global ModuleLoaded fzf %{
      map global user -docstring "fuzzyfind file" 'f' '<esc>: require-module fzf-file; fzf-file<ret>'
      map global user -docstring "fuzzyfind buffer" 'b' '<esc>: require-module fzf-buffer; fzf-buffer<ret>'
    }

    # otherwise custom user-mode keymappings
    map global user <space> <space> -docstring 'remove all selections except main'
    map global user -docstring "delete buffer" 'd' ': delete-buffer<ret>'
    map global user -docstring "next buffer" 'n' ': buffer-next<ret>'
    map global user -docstring "prev buffer" 'p' ': buffer-next<ret>'
    map global user -docstring "list buffers" 'l' ': info-buffers<ret>'

    plug "lePerdu/kakboard" %{
        hook global WinCreate .* %{ kakboard-enable }
    }

    # switch to space as a leader key
    map global normal <space> , -docstring 'leader'
    require-module fzf
  '';
}
