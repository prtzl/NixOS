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
    # Plugins that I know and understand where and how they're used
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars)) # syntax for everything
    jellybeans-vim # theme
    vim-cpp-enhanced-highlight # better looking cpp highlighting
    markdown-preview-nvim # opens markdown preview in browser
    fzfWrapper # fzf stuff
    fzf-vim # as well
    vim-nix # nix format
    nerdtree # Sidebar with files
    nerdtree-git-plugin # same
    vim-nerdtree-syntax-highlight # more nerdtree
    vimtex # tex formatting
    neoformat # runs formatter for a file
    lightline-vim # status bar
    vim-gitbranch # get git info for status bar
    coc-fzf # seach
    coc-nvim # autosuggest
    coc-git # gutter is labeled when stuff is added, changed or removed
    coc-json # JSON tools
    
    # Plugins that are here and might break my config but I don't know them ...
    #coc-clangd # this one starts complaining for everything - c++14> not found
  ];
in {
  home.packages = with pkgs; [ bat ripgrep ];
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
