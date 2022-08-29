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
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars)) # syntax for everything
    jellybeans-vim
    vim-cpp-enhanced-highlight
    #coc-clangd
    coc-fzf
    coc-git
    coc-json
    coc-nvim
    fzf-lsp-nvim
    fzfWrapper
    fzf-vim
    incsearch-vim
    neoformat
    nerdtree
    nerdtree-git-plugin
    vim-airline
    vim-nerdtree-syntax-highlight
    vim-lsp
    vim-nix
    vimtex
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
