let g:polyglot_disabled = ['latex']

" ensure plug is installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set nocompatible
set hidden
set encoding=utf-8
call plug#begin('~/.vim/plugged')
" Control Space
Plug 'vim-ctrlspace/vim-ctrlspace'
" The javascript syntax/formatting I prefer
Plug 'jelera/vim-javascript-syntax'
" Clojure stuff
"Plug 'guns/vim-clojure-static'
" Clojure stuff
"Plug 'tpope/vim-classpath'
" more Clojure stuff
"Plug 'tpope/vim-fireplace'
" In time-out because it conflicts with cmake highlighting
"Plug 'kien/rainbow_parentheses.vim'
" The bottom bar
Plug 'vim-airline/vim-airline'
" Themes for that bottom bar
Plug 'vim-airline/vim-airline-themes'
" Syntax highlighting/formatting for many many languages
Plug 'sheerun/vim-polyglot'
" Wakatime code dashboard integration
Plug 'wakatime/vim-wakatime'
" git integration
Plug 'tpope/vim-fugitive'
" projectionist
Plug 'tpope/vim-projectionist'
" PDF viewer
Plug 'makerj/vim-pdf'
" Latex compiler
" Plug 'lervag/vimtex'
" Elixir Formatter
"Plug 'mhinz/vim-mix-format'
" decent theme
"Plug 'kristijanhusak/vim-hybrid-material'
" solid theme
" Plug 'rdavison/Libertine'
" scribble syntax highlighting
"Plug 'nickng/vim-scribble'
" colorscheme pack
" Plug 'flazz/vim-colorschemes'
" my colorscheme
Plug 'the-mikedavis/firebird'
Plug 'mcchrish/nnn.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'smallwat3r/efficient', { 'commit': 'b895b0c393345a8657b3d8477d6a14132ada64b3' }
Plug 'dense-analysis/ale'
Plug 'JamshedVesuna/vim-markdown-preview'
" nord colorscheme
Plug 'arcticicestudio/nord-vim'
" Plug 'co1ncidence/mountaineer'
" Plug 'co1ncidence/gunmetal'
Plug 'w0ng/vim-hybrid'
Plug 'mboughaba/i3config.vim'
call plug#end()

let g:libertine_Sunset = 1

syntax enable

"   Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
"   keep selection after indentation
vnoremap < <gv
vnoremap > >gv
"   Switch to spaces of width 2
set tabstop=2
set shiftwidth=2
set expandtab
set hlsearch
"set nu "show line numbers
" do hybrid line numbers
set number relativenumber
"set ruler "   Show the column and such
" fish conflicts with Vundle.vim
" use zsh when using PluginInstall
set shell=fish
"set shell=/usr/local/bin/zsh
"set shell=/bin/bash

" let g:airline_theme = onedark

"   For makefiles, turn tabs back on
autocmd FileType make setlocal noexpandtab

"let g:rbpt_colorpairs = [
"    \ ['brown',       'RoyalBlue3'],
"    \ ['Darkblue',    'SeaGreen3'],
"    \ ['darkgray',    'DarkOrchid3'],
"    \ ['darkgreen',   'firebrick3'],
"    \ ['darkcyan',    'RoyalBlue3'],
"    \ ['darkred',     'SeaGreen3'],
"    \ ['darkmagenta', 'DarkOrchid3'],
"    \ ['brown',       'firebrick3'],
"    \ ['gray',        'RoyalBlue3'],
"    \ ['black',       'SeaGreen3'],
"    \ ['darkmagenta', 'DarkOrchid3'],
"    \ ['Darkblue',    'firebrick3'],
"    \ ['darkgreen',   'RoyalBlue3'],
"    \ ['darkcyan',    'SeaGreen3'],
"    \ ['darkred',     'DarkOrchid3'],
"    \ ['red',         'firebrick3'],
"    \ ]
"let g:rbpt_max = 16
"let g:rbpt_loadcmd_toggle = 0

"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound

" not perl, prolog
au BufReadPost *.pl set syntax=prolog

" draw a gray color column at col 80
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

if has('gui_running') || has('nvim')
  hi Normal guifg=#afafaf guibg=#242424
else
  hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
  " let &t_ti = &t_ti . "\033]10;#afafaf\007\033]11;#242424\007"
  let &t_te = &t_te . "\033]110\007\033]111\007"
endif

" allow backspacing on newlines in vim 8
set backspace=indent,eol,start

" configure the mix formatting plugin
let g:mix_format_on_save = 1
let g:mix_format_options = '--check-equivalent'
let g:mix_format_silent_errors = 1

" enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='✱'

let g:nnn#action = { '<c-v>': 'vsplit' }

" turn on smart case search
set ignorecase
set smartcase
" turn off 'fIlE cHaNgEd' thing
set noconfirm
"set iskeyword-=_

command Coverage call system('open cover/excoveralls.html')
command Docs call system('open doc/index.html')

" ale configuration
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

let g:ale_linters = {}
let g:ale_linters.elixir = ['elixir-ls']

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fixers.elixir = ['mix_format']

let g:ale_sign_column_always = 1
let g:ale_elixir_credo_strict = 1

let g:ale_elixir_elixir_ls_release = expand("~/elixir-ls/rel")
let g:ale_elixir_elixir_ls_config= {'elixirLS': {'dializerEnabled': v:false}}

nnoremap K :ALEHover<cr>

" end ale config

" colorscheme onehalfdark
" colorscheme nord
" set background=dark
colorscheme efficient
let g:airline_theme='hybrid'
let g:airline#extensions#ale#enabled = 1

" use github syntax and style
let vim_markdown_preview_github=1
" use C-m to start and refresh previews
let vim_markdown_preview_hotkey='<C-m>'
" refresh the preview on command (<C-m>)
let vim_markdown_preview_toggle=0
" remove the rendered file after vim is closed
let vim_markdown_preview_temp_file=1
