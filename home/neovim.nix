{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ nixfmt neovim-qt ];

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
      set wildmenu
      set showcmd
      set showmatch
      set mouse=a

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

      " Experiments
      set wildmode=list:full
    '';
  };
}
