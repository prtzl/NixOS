"load system defaults
if filereadable(expand('$VIMRUNTIME/defaults.vim'))
	unlet! g:skip_defaults_vim
	source $VIMRUNTIME/defaults.vim
endif

"regular settings
"----------------
" ui
set number
set ruler
set showcmd
set showmode
set showmatch
set mouse=a
set laststatus=0

" Colorscheme
colorscheme jellybeans

" Improved cpp
let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1

" Tab complete
set wildmenu
set wildmode=list:full
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Do not save backup files.
set nobackup
set history=1000

" Cursor
set guicursor=
inoremap <Esc> <Esc>l
set cursorline
set scrolloff=5

" Clipboard
set clipboard+=unnamedplus

" encoding/format
set encoding=utf-8
set fileformats=unix,dos,mac

" searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" indent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set nowrap

" key timeout values
set ttimeoutlen=20
set timeoutlen=1000

" allow syntax and filetype plugins
syntax enable
filetype plugin indent on

" Ctrl+Backspace delete word in insert mode
set backspace=indent,eol,start
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Auto bracket closing
imap "<tab> ""<Left>
imap '<tab> ''<Left>
imap (<tab> ()<Left>
imap [<tab> []<Left>
imap {<tab> {}<Left>
imap {<CR> {<CR>}<ESC>O
imap {;<CR> {<CR>};<ESC>O

" Print opened file in tmux bar
if exists('$TMUX')
  let windowName = system("tmux display-message -p '#W'")
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window 'nvim(" . expand("%:t") . ")'")
  autocmd VimLeave * call system("tmux rename-window " . windowName)
endif
