{ config, pkgs, ... }:

let
  plugins = {
    stable = pkgs.vimPlugins;
    unstable = pkgs.unstable.vimPlugins;
    master = pkgs.unstable.vimPlugins;
    local = pkgs.local.vimPlugins;
  };
in {
  home.packages = with pkgs; [
    nixpkgs-fmt neovim-qt
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with plugins.master; [
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
    extraConfig = builtins.readFile ./dotfiles/init.vim;
  };
}
