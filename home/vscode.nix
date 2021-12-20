{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    vscode-fhs
    #vscode-with-extensions
    #vscode-extensions.ms-vsliveshare.vsliveshare 
    #vscode-extensions.ms-python.python
    #vscode-extensions.ms-vscode.cpptools
    #vscode-extensions.donjayamanne.githistory
    #vscode-extensions.file-icons.file-icons
  ];
}
