# Stolen shit from: https://github.com/p3t33/nixos_flake/blob/master/modules/home-manager/tmux.nix

{ pkgs, ... }:

let
  pkgs_tmux = pkgs.unstable;
  resurrectDirPath = "~/.config/tmux/resurrect";
in {
  programs.tmux = {
    enable = true;
    package = pkgs_tmux.tmux;
    extraConfig = ''
      # This command is executed to address an edge case where after a fresh install of the OS no resurrect
      # directory exist which means that the continuum plugin will not work. And so without user
      # manually saving the first session(prfix + Ctrl+s) no resurrect-continuum will occur.
      #
      # And in case user does not remember to save his work for the first time and tmux daemon gets
      # restarted next time user will try to attach, there will be no state to attach to and user will
      # be scratching his head as to why.
      #
      # Saving right after fresh install on first boot of the tmux daemon with no sessions will create an
      # empty "last" session file which might cause all kind of issues if tmux gets restarted before
      # the user had the chance to work in it and let continuum plugin to take over and create
      # at least one valid "snapshot" from which tmux will be able to resurrect. This is why an initial
      # session named init-resurrect is created for resurrect plugin to create a valid "last" file for
      # continuum plugin to work off of.
      run-shell "if [ ! -d ${resurrectDirPath} ]; then tmux new-session -d -s init-resurrect; ${pkgs_tmux.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh; fi"
    '' + (builtins.readFile ./dotfiles/tmux/tmux.conf);
    plugins = with pkgs_tmux.tmuxPlugins; [{
      plugin = resurrect;
      extraConfig = ''
        # I have tested this strategy to work with neovim but it is not enough to have
        # Session.vim at the root of the path from which the plugin is going to do the restore
        # it is important that for neovim to be saved to be restored from the path where Session.vim
        # exist for this flow to kick in. Which means that even if tmux-resurrect saved the path with
        # Session.vim in it but vim was not open at the time of the save of the sessions then when
        # tmux-resurrect restore the window with the path with Session.vim nothing will happen.

        # Furthermore I am currently using vim-startify which among other things is able to restore
        # from Session.vim if neovim is opened from the path where Session.vim exist. So in a
        # sense I don't really need tmux resurrect to restore the session as this already
        # taken care of and this functionality becomes redundant. But as I am not sure if I keep
        # using vim-startify or its auto restore feature and it do not conflict in any way that
        # I know of with set -g @resurrect-strategy-* I decided to keep it enabled for the time being.
        set -g @resurrect-strategy-nvim 'session'
        set -g @resurrect-strategy-vim 'session'

        set -g @resurrect-capture-pane-contents 'on'

        # This three lines are specific to NixOS and they are intended
        # to edit the tmux_resurrect_* files that are created when tmux
        # session is saved using the tmux-resurrect plugin. Without going
        # into too much details the strings that are saved for some applications
        # such as nvim, vim, man... when using NixOS, appimage, asdf-vm into the
        # tmux_resurrect_* files can't be parsed and restored. This addition
        # makes sure to fix the tmux_resurrect_* files so they can be parsed by
        # the tmux-resurrect plugin and successfully restored.
        set -g @resurrect-dir ${resurrectDirPath}
        # set -g @resurrect-hook-post-save-all 'sed -i -E "s|(pane.*nvim\s*:)[^;]+;.*\s([^ ]+)$|\1nvim \2|" ${resurrectDirPath}/last'
        set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g" $target | sponge $target'
      '';
    }];
  };
}
