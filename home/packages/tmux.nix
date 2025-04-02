{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    package = pkgs.unstable.tmux;
    extraConfig = (builtins.readFile ./dotfiles/tmux/tmux.conf) + ''
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-capture-pane-contents 'on'
    '';
  };
}
