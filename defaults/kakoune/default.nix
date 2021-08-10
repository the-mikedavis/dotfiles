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
    # source ~/.config/kak/coerce.kak

    map global normal + ': coerce-mode<ret>' -docstring 'coercion mode'

    plug "occivink/kakoune-sudo-write"
    plug "delapouite/kakoune-buffers"

    plug "lePerdu/kakboard" %{
        hook global WinCreate .* %{ kakboard-enable }
    }

    plug "the-mikedavis/coerce.kak" %{
      map global user -docstring "coerce mode" 'c' ': coerce-mode<ret>'
    }

    plug "andreyorst/fzf.kak" config %{
    } defer fzf %{
      map global user -docstring "fuzzyfind file in vcs" 'f' '<esc>: require-module fzf-vcs; fzf-vcs<ret>'
      map global user -docstring "fuzzyfind file" 'F' '<esc>: require-module fzf-file; fzf-file<ret>'
      map global user -docstring "fuzzyfind buffer" 'b' '<esc>: require-module fzf-buffer; fzf-buffer<ret>'
      map global user -docstring "interactive grep" 'g' '<esc>: require-module fzf-grep; fzf-grep<ret>'
    }

    # otherwise custom user-mode keymappings
    map global user <space> <space> -docstring 'remove all selections except main'
    map global user -docstring "delete buffer" 'd' ': delete-buffer<ret>'
    map global user -docstring "delete all buffers" 'D' ': delete-buffers<ret>'
    map global user -docstring "next buffer" 'n' ': buffer-next<ret>'
    map global user -docstring "prev buffer" 'p' ': buffer-next<ret>'
    map global user -docstring "list buffers" 'l' ': info-buffers<ret>'
    map global user -docstring "fzf-mode" 'z' ': fzf-mode<ret>'
    map global user -docstring "mkdir -p" 'm' ': mkdir-p<space>'
    map global user -docstring "select all instances" 'a' '*%s<ret>'
    map global user -docstring "git status" 's' ': git status<ret>'

    # custom git bindings in a user-mode
    declare-user-mode git
    map global git -docstring "status" 's' ': git status<ret>'
    map global git -docstring "commit" 'c' ': git commit<ret>'
    map global git -docstring "add" 'a' ': git add<space>'
    map global normal -docstring "enter git mode" '+' ': enter-user-mode git<ret>'

    # switch to space as a leader key
    map global normal <space> , -docstring 'leader'

    define-command mkdir-p -params 1 %{ nop %sh{ mkdir -p "$1" }}

    require-module fzf
  '';
}
