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
    (nvim-treesitter.withPlugins (_: pkgs.unstable.tree-sitter.allGrammars)) # syntax for everything
    jellybeans-vim # theme
    vim-cpp-enhanced-highlight # better looking cpp highlighting
    markdown-preview-nvim # opens markdown preview in browser
    fzfWrapper # fzf stuff
    fzf-vim # as well
    vim-nix # nix format
    vimtex # tex formatting
    lightline-vim # status bar
    vim-gitbranch # get git info for status bar
    impatient-nvim
    gitsigns-nvim
    incsearch-vim
    colorizer # preview hex color codes  - why not
    nvim-autopairs
    nvim-tree-lua
    nvim-web-devicons

    # LSP stuff
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-omni
    cmp-path
    cmp-treesitter
    cmp_luasnip
    fidget-nvim
    fzf-lsp-nvim
    lsp_extensions-nvim
    lsp_signature-nvim
    luasnip
    nvim-cmp
    nvim-dap
    nvim-dap-ui
    nvim-lspconfig
    plenary-nvim

    # Plugins that are here and might break my config but I don't know them ...
    #YouCompleteMe
  ];
in {
  home.packages = with pkgs; [ bat ripgrep rnix-lsp ];
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
      ${builtins.readFile ./dotfiles/vim/init.vim}
      lua << EOF
      ${builtins.readFile ./dotfiles/vim/init.lua}
      EOF
    '';
  };
}
