-- Base gui
vim.opt.number = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showmatch = true
vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.laststatus = 2
vim.opt.wildmenu = true
vim.opt.wildmode = { list = 'full' }
vim.opt.guicursor = ''
vim.opt.cursorline = true

-- System
vim.opt.backup = false
vim.opt.history = 1000
vim.opt.scrolloff = 5

-- Clipboard
vim.opt.clipboard:append { 'unnamedplus' }

-- Format
vim.opt.encoding = 'utf8'
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.wrap = false

-- Window split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Timeout
vim.opt.ttimeoutlen=20
vim.opt.timeoutlen=1000

-- Misc
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Can't be bothered to port
vim.cmd([[
    "" Status bar - lightline
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
]])
