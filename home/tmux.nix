{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"

      # Move tmux "namespace" command from Ctrl+b to Ctrl+space
      unbind C-b
      set -g prefix C-Space

      # Bing r as reload key
      unbind r
      bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf"

      # Mouse mode
      set -g mouse on

      # Remap split commands
      unbind v
      unbind h

      unbind % # Split vertically
      unbind '"' # Split horizontally

      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"

      # More history
      set -g history-limit 100000

      # Window navigation
      unbind n  #DEFAULT KEY: Move to next window
      unbind w  #DEFAULT KEY: change current window interactively

      bind n command-prompt "rename-window '%%'"
      bind w new-window -c "#{pane_current_path}"

      bind -n C-PageUp previous-window
      bind -n C-PageDown next-window

      # Windows and panes begin at 1
      set -g base-index 1
      set-window-option -g pane-base-index 1

      #### COLOR (Solarized dark)
      set-option -g status-style fg=yellow,bg=black #yellow and base02
      set-window-option -g window-status-style fg=brightblue,bg=default #base0 and default
      set-window-option -g window-status-current-style fg=brightred,bg=default #orange and default
      set-option -g pane-border-style fg=black #base02
      set-option -g pane-active-border-style fg=brightgreen #base01
      set-option -g message-style fg=brightred,bg=black #orange and base01
      set-option -g display-panes-active-colour blue #blue
      set-option -g display-panes-colour brightred #orange
      set-window-option -g clock-mode-colour green #green
      set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
    '';
  };
}
