alias v="vim"
funcsave v
alias c="cd"
funcsave c
alias e="exa"
funcsave e
# alias g="git"
# funcsave g
alias t="tmux"
funcsave t
alias h="history"
funcsave h
alias cr="clear"
funcsave cr
alias ty="type"
funcsave ty
alias aoeu="asdf"
funcsave aoeu
alias ex="vim -c 'Explore'"

# mix
alias mff="mix format --check-formatted"
funcsave mff
alias mfe="mix format --check-equivalent"
funcsave mfe
alias mb="mix bless"
funcsave mb
alias mfb="mix format --check-equivalent; and mix bless"
funcsave mfb
alias md="mix do"
funcsave md
alias mcc="mix do clean, compile"
funcsave mcc
alias mch="mix coveralls.html"

function iet --description 'iex in test mode'
  set -lx MIX_ENV test
  iex $argv
end

function ve --description 'read everything in tabs'
  if test -d $argv[1]
    vim -p $argv[1]*
  else if set -q $argv[1]
    vim -p *
  else
    vim -p $argv[1]
  end
end
funcsave ve

function gerge --description 'take in a github pr merge locally'
  set branch (git rev-parse --abbrev-ref HEAD)
  git checkout master
  git pull
  git branch -d $branch
  git eggplant # prune origin stuff
end
funcsave gerge
 
alias drs 'darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix'
funcsave drs

function nfic --description 'clone a repo from NFIBrokerage'
  git clone git@github.com:NFIBrokerage/$argv
end
