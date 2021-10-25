{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-fzf-tab
  ];

  programs.direnv = { 
    enable = true;
    enableZshIntegration = true;
  };  

  programs.starship = { 
    enable = true;
    enableZshIntegration = true;
    settings = { 
      add_newline = false;
      character = { 
        success_symbol = "[»](bold green)";
        error_symbol = "[»](bold green)";
        vicmd_symbol = "[«](bold green)";
      };
      username = {
        disabled = false;
        show_always = true;
        style_root = "bold red";
        style_user = "blue yellow";
        format = "[$user]($style)";
      };
      hostname = {
        disabled = false;
        ssh_only = false;
        style = "bold dimmed green";
        format = "[@$hostname]($style)";
      };
      directory = {
        truncation_length = 10;
        disabled = false;
        truncate_to_repo = false;
        style = "bold cyan";
        format = "[:$path]($style)";
      };
      git_branch = {
        style = "bold purple";
        format = "[ $symbol$branch]($style)";
      };
      git_status = {
        style = " bold yellow";
        format = "[ $all_status]($style)";
      };
      nix_shell = {
        symbol = "❄️";
        style = "bold blue";
        format = " [$symbol  $name]($style)";
      };
      cmake.disabled = true;
      python.disabled = true;
    };  
  };

 
  programs.zsh = {
    enable = true;
    shellAliases = {
      vi="vim";
      ls="ls --group-directories-first --color=auto";
      l="ls -la";
      ll="ls -l";
      pdf="evince";
    };

    history = {
      size = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = false;
      path = "$HOME/.cache/zsh/history";
    };

    plugins = with pkgs; [ 
      {
        name = "zsh-syntax-highlighting";
        src = builtins.fetchGit {
          url = https://github.com/zsh-users/zsh-syntax-highlighting.git;
        };
      }
    ];

    initExtra = ''
      # Pimped out auto/tab complete:
      autoload -U colors && colors
      autoload -U compinit && compinit
      zstyle ':completion:*' completer _extensions _complete _approximate
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' file-sort dummyvalue
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*:parameters'  list-colors '=*=32'
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)       # Include hidden files.

      # Add history command complete
      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey "^[[A" history-beginning-search-backward-end
      bindkey "^[[b" history-beginning-search-forward-end

      # F$cked keys, give them back
      bindkey "^[[3~" delete-char
      bindkey "^[[3;5~" delete-char
      bindkey '^H' backward-kill-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '\e[11~' "urxvt &\n"
    '';
  };

  home.sessionVariables = {
    LS_COLORS = "$LS_COLORS:ow=1;34:tw=1;34:";
  };

 }

