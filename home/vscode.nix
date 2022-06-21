{ config, pkgs, ...}:

let
  #unstable = pkgs.unstable;
  unstable = import <nixpkgs> {};
in {
  home.packages = with pkgs; [
    (unstable.vscode-with-extensions.override {
      vscodeExtensions = with unstable.vscode-extensions; [
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        ms-vsliveshare.vsliveshare
        vscodevim.vim
        ms-vscode.cpptools
      ];
    })
  ];
}
