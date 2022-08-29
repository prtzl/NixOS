{ config, pkgs, lib, ... }:

let
  vimPlugins = {
    stable = pkgs.vimPlugins;
    unstable = pkgs.unstable.vimPlugins;
    local = pkgs.local.vimPlugins;
  };
  loadPlugin = plugin: ''
    set rtp^=${plugin}
    set rtp+=${plugin}/after
  '';
  unlines = lib.concatStringsSep "\n";
  loadPlugins = ps: lib.pipe ps [ (builtins.map loadPlugin) unlines ];
  plugins = with vimPlugins.unstable; [
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
    fzf-vim
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
    vim-lsp
    vim-lsc
    vimtex
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars)) # syntax for everything
  ];
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraConfig = ''
      " Workaround for broken handling of packpath by vim8/neovim for ftplugins -- see https://github.com/NixOS/nixpkgs/issues/39364#issuecomment-425536054 for more info
      filetype off | syn off
      ${loadPlugins plugins}
      filetype indent plugin on | syn on
      ${builtins.readFile ./dotfiles/init.vim}
    '';
  };
}
