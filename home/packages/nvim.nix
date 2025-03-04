{ config, pkgs, lib, system, ... }:

let
  pkgs-nvim = pkgs;
  mynvim = pkgs.nvimnix.packages.x86_64-linux.default; # this is oh shit moment. But it works hahahah
in
{
  # My fancy pantsy portable nvimnix does not bring it's own programs, so keep this here for now
  home.packages = with pkgs-nvim; [
    bat
    ripgrep
    mynvim
  ] ++ (with pkgs-nvim; [
    nil # nix lsp
    texlab # latex lsp
    python311Packages.python-lsp-server # python lsp
    sumneko-lua-language-server # lua lsp
    tree-sitter
    lazygit
  ]);
  # programs.neovim = {
  #   enable = true;
  #   package = pkgs.nvimnix.packages.x86_64-linux.default;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  #   withNodeJs = true;
  #   withPython3 = true;
  # };
}
