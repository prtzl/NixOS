{ config, pkgs, lib, ... }:

let
  # All packages related to function of nvim are from separate pkgs-nvim
  pkgs-nvim = pkgs.unstable; # pkgs.pkgs-nvim;
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
    telescope-nvim # Fuzzy search
    telescope-frecency-nvim # 
    lualine-nvim # status bar
    vim-gitbranch # get git info for status bar
    gitsigns-nvim # git gutter
    vim-fugitive # Git tool
    lazygit-nvim # Another git tool
    impatient-nvim # Everyone and their mother includes this
    incsearch-vim
    nvim-autopairs # autopair braces
    nvim-tree-lua # file tree
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
    cmp-emoji
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
    rev = "843c23847bf613c7966a9412e9969d7b240483e9";
    sha256 = "sha256-/0FIxCv5b/+eFNDHhLLgROUwEytIzJy/0sYMMarqljc=";
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
    lazygit
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
