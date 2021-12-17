{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ nixfmt ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      base16-vim
      coc-clangd
      coc-fzf
      coc-git
      coc-json
      coc-nvim
      delimitMate
      fzf-lsp-nvim
      fzfWrapper
      incsearch-vim
      neoformat
      nerdtree
      nerdtree-git-plugin
      tagbar
      vim-airline
      vim-code-dark
      vim-devicons
      vim-nerdtree-syntax-highlight
      vim-nix
      vim-pug
      vim-vue
      vimtex
    ];
    extraConfig = ''
      set nocompatible            " disable compatibility to old-time vi
      set showmatch               " show matching 
      set ignorecase              " case insensitive 
      set mouse=v                 " middle-click paste with 
      set hlsearch                " highlight search 
      set incsearch               " incremental search
      set tabstop=4               " number of columns occupied by a tab 
      set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
      set expandtab               " converts tabs to white space
      set shiftwidth=4            " width for autoindents
      set autoindent              " indent a new line the same amount as the line just typed
      set number                  " add line numbers
      set wildmode=longest,list   " get bash-like tab completions
      filetype plugin indent on   "allow auto-indenting depending on file type
      syntax on                   " syntax highlighting
      set mouse=a                 " enable gruvboxmouse click
      set clipboard+=unnamedplus   " using system clipboard
      filetype plugin on
      set cursorline              " highligruvboxght current cursorline
      set ttyfast                 " Speed up scrolling in Vim

      nnoremap <silent> <space><space> :<C-u>CocFzfList<CR>
      nnoremap <silent> <space>a       :<C-u>CocFzfList diagnostics<CR>
      nnoremap <silent> <space>b       :<C-u>CocFzfList diagnostics --current-buf<CR>
      nnoremap <silent> <space>c       :<C-u>CocFzfList commands<CR>
      nnoremap <silent> <space>e       :<C-u>CocFzfList extensions<CR>
      nnoremap <silent> <space>f       :<C-u>CocFzfList gfiles<CR>
      nnoremap <silent> <space>l       :<C-u>CocFzfList location<CR>
      nnoremap <silent> <space>o       :<C-u>CocFzfList outline<CR>
      nnoremap <silent> <space>s       :<C-u>CocFzfList symbols<CR>
      nnoremap <silent> <space>p       :<C-u>CocFzfListResume<CR>
    '';
  };
}
