{ config, pkgs, ... }:

let
  plugins = {
    stable = pkgs.vimPlugins;
    unstable = pkgs.vimPlugins;
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
    plugins = with plugins.unstable; [
      jellybeans-vim
      vim-cpp-enhanced-highlight
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
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars)) # syntax for everything
    ];
    extraConfig = builtins.readFile ./dotfiles/init.vim;
  };
}
