set nocompatible

" nvim's python provider (for jedi-vim) lives in its own venv, see setup.sh
let s:nvim_python = expand('~/.local/share/nvim/venv/bin/python')
if has('nvim') && executable(s:nvim_python)
  let g:python3_host_prog = s:nvim_python
endif

" Spacebar is a much better leader than \ or ,
let mapleader = "\<Space>"

" Automatically source the vimrc file after saving it
augroup vimrc_reload
  autocmd!
  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

""" Defaults
Plug 'tpope/vim-sensible'
Plug 'rstacruz/vim-opinion'

""" Editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rsi'  " unix keybindings in insert mode
Plug 'wellle/targets.vim'  " because cin), etc. is awesome
Plug 'Raimondi/delimitMate'  " autoclose parens, quotes, etc.
Plug 'terryma/vim-multiple-cursors'
Plug 'ervandew/supertab', { 'branch': 'main' }
Plug 'honza/vim-snippets'

Plug 'tpope/vim-commentary'
" Toggle comment with space-/
nmap <leader>/ gcc
vmap <leader>/ gc

""" Moving around
Plug 'justinmk/vim-sneak'
Plug 'vim-scripts/matchit.zip'
" <C-h/j/k/l> moves between vim splits and tmux panes
Plug 'christoomey/vim-tmux-navigator'

""" Finding files and text
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
" Go to symbol
map <leader>r :CtrlPFunky<CR>
let g:ctrlp_funky_syntax_highlight = 1

Plug 'mileszs/ack.vim'
if executable('rg')
  let g:ackprg = 'rg --vimgrep --smart-case'
  set grepprg=rg\ --vimgrep\ --smart-case
  let g:ctrlp_user_command = 'rg %s --files --color=never'
elseif executable('ag')
  let g:ackprg = 'ag --vimgrep'
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
nnoremap <leader>f :Ack!<space>
Plug 'stefandtw/quickfix-reflector.vim'  " edit the quickfix list to edit files

Plug 'scrooloose/nerdtree'
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>D :NERDTreeFind<CR>
" Single clicks open directories and files
let g:NERDTreeMouseMode = 3
let g:NERDTreeRespectWildIgnore = 1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

Plug 'majutsushi/tagbar', {'on': 'Tagbar'}
map <leader>\ :Tagbar<CR>
let g:tagbar_autofocus = 1

""" Buffers and windows
Plug 'moll/vim-bbye'
nnoremap X :Bdelete<CR>
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/ZoomWin'
Plug 'wesQ3/vim-windowswap'
Plug 'tpope/vim-obsession'

Plug 'duff/vim-scratch'
" Toggle a scratch buffer with space-tab
command! ScratchToggle call ScratchToggle()
function! ScratchToggle()
  if exists("w:is_scratch_window")
    unlet w:is_scratch_window
    exec "q"
  else
    exec "normal! :Sscratch\<cr>\<C-W>L"
    let w:is_scratch_window = 1
  endif
endfunction
nnoremap <silent> <leader><tab> :ScratchToggle<cr>

""" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'  " :GBrowse for GitHub
map <leader>gs :Git<CR>
map <leader>gb :Git blame<CR>
" Open current file, or the selected lines, on GitHub
map <leader>gB :GBrowse<CR>
vmap <leader>gB :GBrowse<CR>
map <leader>gr :Gread<CR>
map <leader>gw :Gwrite<CR>
noremap <leader>gp :Git push<CR>

Plug 'airblade/vim-gitgutter', { 'branch': 'main' }
" Set gitgutter's bindings manually to avoid clashes
let g:gitgutter_map_keys = 0
nmap <leader>gh <Plug>(GitGutterStageHunk)
nmap <leader>gH <Plug>(GitGutterUndoHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)

""" Tests
Plug 'tpope/vim-dispatch'  " so we can run tests asynchronously
Plug 'janko-m/vim-test'
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
let test#strategy = "dispatch"
" Pass -s option to pytest so that we can use ipdb
let test#python#pytest#options = '-s'

""" Look
Plug 'bling/vim-airline'
let g:airline#extensions#hunks#enabled = 0
Plug 'flazz/vim-colorschemes'

""" Notes and docs
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
let g:notes_directories = ['~/Documents/Notes']
let g:notes_suffix = '.txt'
Plug 'greyblake/vim-preview'  " preview markdown, rst, etc.
Plug 'rafaelfranca/rtf_pygmentize', {'on': 'RTFPygmentize'}
let g:rtfp_font = 'Ubuntu Mono'

""" Languages

" Python
Plug 'hdima/python-syntax', {'for': 'python'}
let g:python_highlight_all = 1
Plug 'alfredodeza/khuno.vim', {'for': 'python'}  " non-blocking flake8
Plug 'davidhalter/jedi-vim', {'for': 'python'}
let g:jedi#use_tabs_not_buffers = 0
" Just let me type!
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0
" Call signatures slow things down for large projects
let g:jedi#show_call_signatures = 0
" Prefix all refactoring commands with <C-c> to avoid clashing
let g:jedi#goto_command = "<C-c>g"
let g:jedi#rename_command = "<C-c>r"
let g:jedi#usages_command = "<C-c>u"
let g:jedi#documentation_command = "<C-c>d"

" Go
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
let g:go_fmt_command = "goimports"

" Rust
Plug 'rust-lang/rust.vim', {'for': 'rust'}

" Web
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mattn/emmet-vim'  " write HTML fast

" Markdown
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1

" Templates and config
Plug 'stephpy/vim-yaml'
Plug 'chase/vim-ansible-yaml'
Plug 'mitsuhiko/vim-jinja'
Plug 'sophacles/vim-bundle-mako'
Plug 'rodjek/vim-puppet'

" Idris
Plug 'idris-hackers/idris-vim', {'for': 'idris'}

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set autoindent
set autoread " reload files when changed on disk, i.e. via `git checkout`
set backupcopy=yes
set clipboard=unnamedplus
set wildmenu wildmode=longest,list,full
set mouse=a mousemodel=popup " Right-click pops up a menu
set noerrorbells visualbell t_vb=

" Indents
set expandtab " expand tabs by default (overloadable per file type later)
set tabstop=4 " a tab is 4 spaces
set softtabstop=4 " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=4 " number of spaces to use for autoindenting
set shiftround " use multiple of shiftwidth when indenting with '<' and '>'

" Patterns for expand(), ctrlp, etc. to ignore
set wildignore+=log/**,node_modules/**,target/**,tmp/**,.git/*,*/.hg/*,*/.svn/*
set wildignore+=*.o,*.out,*.obj,*.class,*.pyc,*__pycache__*
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*.swp,*~,._*

" Persistent undo, in ./.vim-undo if it exists, otherwise ~/.vim/undo
if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo// undodir+=~/.vim/undo// undofile
endif

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute 'normal! g`"zvzz' |
    \ endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" APPEARANCE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Favorites: hybrid iceberg Tomorrow hybrid-light
silent! colorscheme iceberg

set number relativenumber
set cursorline  " have a line indicate cursor location
set previewheight=25  " Larger preview height
" Set minimum window size to 79x5.
set winwidth=79 winheight=5 winminheight=5
" Show tabs and trailing whitespace
set list listchars=tab:▸\ ,trail:▫
if exists('&breakindent') | set breakindent showbreak=.. | endif

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    echo ':set number'
  else
    set relativenumber
    echo ':set relativenumber'
  endif
endfunc
nnoremap <silent> <leader>n :call NumberToggle()<CR>

" Toggle a transparent background, e.g. to see through to the terminal
command! TransparencyToggle call TransparencyToggle()
function! TransparencyToggle()
  let groups = ['Normal', 'NonText', 'CursorLine', 'CursorLineNr', 'LineNr',
    \ 'GitGutterAdd', 'GitGutterChange', 'GitGutterDelete']
  if exists("w:saved_bgs")
    for group in groups
      exec "hi " . group . " ctermbg=" . w:saved_bgs[group]
    endfor
    unlet w:saved_bgs
  else
    let w:saved_bgs = {}
    for group in groups
      let bg = synIDattr(synIDtrans(hlID(group)), 'bg')
      let w:saved_bgs[group] = empty(bg) ? 'none' : bg
      exec "hi " . group . " ctermbg=none"
    endfor
  endif
endfunction
nnoremap <silent> <leader>o :TransparencyToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smash escape
inoremap jk <Esc>
" Quickly write/quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
" Quickly edit vimrc
nnoremap <leader>, :e $MYVIMRC<CR>
" Switch to the previous file
nnoremap <leader>b :e#<CR>
" Quickly open netrw
nnoremap <leader>e :e.<CR>
" Quick split, and always focus the new split
nnoremap <leader>v <C-w>v<C-w>w
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w
" Move across buffers with arrow keys
nnoremap <silent> <Right> :bnext<CR>
nnoremap <silent> <Left> :bprev<CR>
nnoremap <silent> tt :tabnew<CR>
" Copy whole file
nnoremap <leader>a :%y+<CR>
" Remove trailing whitespace
nnoremap <leader><leader>w :%s/\s\+$//<cr>:let @/=''<CR>
" In case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %
" Select last pasted text
nnoremap gp `[v`]
" Make D and Y act on the rest of the line
nnoremap D d$
nnoremap Y y$
" Go to beginning/end of line
noremap <leader>h ^
noremap <leader>l $
" Execute macro
nnoremap Q @q
" Move vertically over wrapped lines
nnoremap j gj
nnoremap k gk
" Quickly set filetype
nnoremap <leader>Tp :set ft=python<CR>
nnoremap <leader>Tj :set ft=javascript<CR>
nnoremap <leader>Tr :set ft=rst<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILETYPES
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup configgroup
  autocmd!
  autocmd BufNewFile,BufRead *.txt setlocal ft=rst
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType rst,markdown setlocal wrap nolist lbr formatoptions+=nqtl
    \ expandtab shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType yaml,vim setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType gitcommit setlocal nolist textwidth=72
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM ONLY (nvim handles these itself)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')
  set t_Co=256
  if &term =~ '256color' | set t_ut= | endif
  if exists('$TMUX') | set ttymouse=xterm2 | endif

  " Bar cursor in insert mode
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

" MacVim
if has('gui_running')
  set guifont=Sauce\ Code\ Powerline:h12
  if has('mac')
    set transparency=0
    set guioptions-=T guioptions-=r guioptions-=L
  endif
endif
