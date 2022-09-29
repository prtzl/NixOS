" Mandatory settings
syntax on
filetype on
filetype plugin on
filetype indent on
command W w
lua require'impatient'

" ui
set number
set ruler
set showcmd
set showmode
set showmatch
set mouse=a
set noswapfile


" Colorscheme
let g:jellybeans_overrides = {
\    'background': { 'guibg': '000000' },
\}
colorscheme jellybeans


" Status bar - lightline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }


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
set cindent
set nowrap


" Window split - add command to work in insert mode as well
set splitbelow
set splitright


" key timeout values
set ttimeoutlen=20
set timeoutlen=1000


" Ctrl+Backspace delete word in insert mode
set backspace=indent,eol,start


" Fuzzy find
let $BAT_THEME="OneHalfDark"
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_COMMAND="rg --files --ignore-case --sort path"
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=numbers,grid,header-filename --line-range :300 {}'"
command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" Print opened file in tmux bar
if exists('$TMUX')
  let windowName = system("tmux display-message -p '#W'")
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window 'nvim(" . expand("%:t") . ")'")
  autocmd VimLeave * call system("tmux rename-window " . windowName)
endif