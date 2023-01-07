{ config, pkgs, lib, ... }:

let
  # All packages related to function of nvim are from separate pkgs-nvim
  pkgs-nvim = pkgs.pkgs-nvim;
  vimPlugins = pkgs-nvim.vimPlugins;
  loadPlugin = p: ''
    set rtp^=${p.plugin or p}
    set rtp+=${p.plugin or p}/after
  '';
  unlines = lib.concatStringsSep "\n";
  loadPlugins = ps: lib.pipe ps [ (builtins.map loadPlugin) unlines ];
  plugins = with vimPlugins; [
    # Plugins that I know and understand where and how they're used
    (nvim-treesitter.withPlugins (_: pkgs-nvim.tree-sitter.allGrammars)) # syntax for everything
    vim-cpp-enhanced-highlight # better looking cpp highlighting
    markdown-preview-nvim # opens markdown preview in browser
    telescope-nvim
    telescope-frecency-nvim
    lightline-vim # status bar
    vim-gitbranch # get git info for status bar
    impatient-nvim
    gitsigns-nvim # git gutter
    incsearch-vim
    nvim-autopairs # autopair braces
    nvim-tree-lua
    nvim-web-devicons # icons
    nvim-base16 # color themes
    comment-nvim # smart comments
    vim-latex-live-preview # preview latex pdf inside editor
    nvim-ts-rainbow # colored parentheses using treesitter
    alpha-nvim # greet dashboard
    indentLine # Show indentation levels

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
    cmp-nvim-lua
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
  epics = pkgs.fetchFromGitHub {
    owner = "minijackson";
    repo = "epics.nvim";
    rev = "55b253750dde9e2f772f1893c2ffa47e2c281276";
    sha256 = "sha256-TczqbpnQ9FaSFeg2VZBP8Lp5o2oHuBI9IOnEuX1pFXk=";
  };
in
{
  home.packages = with pkgs; [
    bat
    ripgrep
  ] ++ (with pkgs-nvim; [
    rnix-lsp # nix lsp
    texlab # latex lsp
    python39Packages.python-lsp-server # python lsp
    sumneko-lua-language-server # lua lsp
    tree-sitter
  ]);
  programs.neovim = {
    # Default is pkgs.neovim-unwrapped
    package = pkgs-nvim.neovim-unwrapped;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraConfig = ''
      " Workaround for broken handling of packpath by vim8/neovim for ftplugins -- see https://github.com/NixOS/nixpkgs/issues/39364#issuecomment-425536054 for more info
      filetype off | syn off
      ${loadPlugin epics}
      ${loadPlugins plugins}
      filetype indent plugin on | syn on
      ${builtins.readFile ./dotfiles/nvim/init.vim}
      lua << EOF
      ${builtins.readFile ./dotfiles/nvim/init.lua}
      EOF
    '';
  };
  xdg.configFile = {
    "nvim/lua".source = ./dotfiles/nvim/lua;
    "nvim/plugin".source = ./dotfiles/nvim/plugin;
    "nvim/ftplugin".source = ./dotfiles/nvim/ftplugin;
  };
}
