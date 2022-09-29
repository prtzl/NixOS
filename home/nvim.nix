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
    lightline-vim # status bar
    vim-gitbranch # get git info for status bar
    impatient-nvim
    gitsigns-nvim
    incsearch-vim
    colorizer # preview hex color codes  - why not
    nvim-autopairs
    nvim-tree-lua
    nvim-web-devicons
    nvim-base16 # colors2
    colorbuddy-nvim # - does not work - error

    # LSP stuff
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-omni
    cmp-path
    cmp-treesitter
    cmp_luasnip
    cmp-nvim-lsp-document-symbol
    cmp-spell
    fidget-nvim
    fzf-lsp-nvim
    lsp_extensions-nvim
    lsp_signature-nvim
    luasnip
    lspkind-nvim
    nvim-cmp
    nvim-dap
    nvim-dap-ui
    nvim-lspconfig
    plenary-nvim
  ];
in
{
  home.packages = with pkgs; [
    bat
    ripgrep
    rnix-lsp # nix lsp
    texlab # latex lsp
    python39Packages.python-lsp-server # python lsp
  ];
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
      ${builtins.readFile ./nvim/init.vim}
      lua << EOF
      ${builtins.readFile ./nvim/init.lua}
      EOF
    '';
  };
  xdg.configFile = {
    "nvim/lua".source = ./nvim/lua;
    "nvim/plugin".source = ./nvim/plugin;
    #"nvim/ftplugin".source = ./nvim/ftplugin;
  };
}
