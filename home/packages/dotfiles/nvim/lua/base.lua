-- base gui
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
vim.opt.sidescrolloff = 10

-- Clipboard
vim.opt.clipboard:append { 'unnamedplus' }

-- Enable background buffer
vim.o.hidden = true

-- Format
vim.opt.encoding = 'utf8'
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Don't wrap
vim.opt.wrap = false

-- Autoindent
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Window split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Timeout
vim.opt.ttimeoutlen = 20
vim.opt.timeoutlen = 1000

-- Enable backspace on characters
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Grep
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Prevent strange file save behaviour.
-- https://github.com/srid/emanote/issues/180
vim.opt.backupcopy = 'yes'

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
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
    let $FZF_DEFAULT_OPTS="--prompt ':D' --ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=numbers,grid,header-filename --line-range :300 {}'"
    let $FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git' --glob '!.cache' --glob '!.direnv' --sort path"
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, { 'options': "--prompt '> ' --ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=numbers,grid,header-filename --line-range :300 {}'"}, <bang>0)

    " Print opened file in tmux bar
    if exists('$TMUX')
      let windowName = system("tmux display-message -p '#W'")
      autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window 'nvim(" . expand("%:t") . ")'")
      autocmd VimLeave * call system("tmux rename-window " . windowName)
    endif
]])
