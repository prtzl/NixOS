{ pkgs, ... }:

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
    wslgit
    xclip
    zsh-completions
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

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
      img = "eog";
      play = "celluloid";
      sl = "sl -ead -999";
      gvim = "nvim-qt";

      # System
      reboot = ''
        read -s \?"Reboot? [ENTER]: " && if [ -z "$REPLY" ];then env reboot;else echo "Canceled";fi'';
      poweroff = ''
        read -s \?"Poweroff? [ENTER]: " && if [ -z "$REPLY" ];then env poweroff;else echo "Canceled";fi'';
      udevreload =
        "sudo udevadm control --reload-rules && sudo udevadm trigger";

      git = "wslgit";
    };

    history = {
      size = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = false;
      path = "$HOME/.cache/zsh/history";
    };

    initExtra = ''
      autoload -U colors && colors

      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      _comp_options+=(globdots)


      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh


      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/lib/zsh-ls-colors/ls-colors.zsh


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
    '';
  };

  home.file.".profile.home".text = ''
    # This file should be sourced by ~/.profile
    # This is currently just for non-nixos platforms
    # Options for non-nixos systems
    if [ ! -d "/etc/nixos" ]; then
      export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
      export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"''${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
    fi
  '';

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
}

