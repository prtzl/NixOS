{ pkgs, lib, homeArgs, ... }:

let
  wslgit =
    pkgs.writeShellScriptBin "wslgit" (builtins.readFile ./dotfiles/wslgit.sh);
in {
  imports = [ ./starship.nix ];

  home.packages = with pkgs; [
    bat
    eza
    fd
    fzf
    lazygit
    ripgrep
    tree
    wslgit
    xclip
    zsh-completions
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetOptions = [
      "--walker-skip .git,node_modules,target"
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];
    changeDirWidgetOptions = [
      "--walker-skip .git,node_modules,target"
      "--preview 'tree -C {}'"
    ];
    historyWidgetOptions = [
      "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
      "--color header:italic"
      "--header 'Press CTRL-Y to copy command into clipboard'"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      # Utilities
      ls = "eza --group-directories-first --color=always --icons";
      l = "ls -la";
      ll = "ls -l";
      grep = "grep --color=always -n";
      ssh = "ssh -C";
      xclip = "xclip -selection clipboard";

      # Programs
      pdf = "evince";
      img = "";
      play = "celluloid";
      sl = "sl -ead -999";
      vim = "nvim";
      gvim = "nvim-qt";

      # System
      reboot = ''read -s \?"Reboot? [ENTER]: " && if [ -z "$REPLY" ];then env reboot;else echo "Canceled";fi'';
      poweroff = ''read -s \?"Poweroff? [ENTER]: " && if [ -z "$REPLY" ];then env poweroff;else echo "Canceled";fi'';
      udevreload = "sudo udevadm control --reload-rules && sudo udevadm trigger";

      git = "wslgit";
    };

    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 100000;
      share = true;
      size = 100000;
    };

    initContent = ''
      autoload -U colors && colors

      # Add history command complete
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down      

      # F$cked keys, give them back
      bindkey "^[[3~" delete-char
      bindkey "^[[3;5~" delete-char
      bindkey '^H' backward-kill-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '\e[11~' "urxvt &\n"

      # Add paths that can be missing sometimes (non-nixos)
      export PATH=$PATH:/usr/sbin:/usr/local/sbin

      export DIRENV_LOG_FORMAT=""

      viewimage() {
        gthumb "''${@:-.}" >/dev/null 2>&1 & disown
      }

      usage() {
        du -h "''${1:-.}" --max-depth=1 2> /dev/null | sort -hr
      }
    '';
  };

  home.file.".zprofile".text = ''
    # Source global profile
    [[ -e "$HOME/.profile" ]] && emulate sh -c 'source $HOME/.profile'
    # Launch DE on non-nixos if available
    if [ ! -d "/etc/nixos" ]; then
      if [ -f "$HOME/.startx.home" ]; then
        source $HOME/.startx.home
      fi
    fi
  '';

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
    TERM = "xterm-256color";
  };

  home.file.".profile.home" = lib.mkIf (homeArgs ? notNixos ? homeArgs.notNixos) {
    text = ''
      # This file should be sourced by ~/.profile
      # This is currently just for non-nixos platforms
      # Options for non-nixos systems
      if [ ! -d "/etc/nixos" ]; then
      export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
      export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"''${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
      fi
    '';
  };
}
