{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ fzf zsh-completions xclip ];

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
        conflicted = "🏳";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++\($count\)](green)";
        up_to_date = "✓";
        ahead = "⇡\($count\)";
        diverged = "⇕⇡\($ahead_count\)⇣\($behind_count\)";
        behind = "⇣\($count\)";
        style = " bold yellow";
        format = "[ $all_status]($style)";
      };
      nix_shell = {
        symbol = "❄️";
        style = "bold blue";
        format = "[ $symbol  $name ]($style)";
      };
      cmake.disabled = true;
      python.disabled = true;
    };  
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellGlobalAliases = {
      # Manage updating
      update = "sudo nix-channel --update";
      aps = "sudo nixos-rebuild switch";
      upgrade = "update && aps";

      # Utilities 
      nix-shell = "nix-shell --command zsh";
      ls = "ls --group-directories-first --color=auto";
      l = "ls -la";
      ll = "ls -l";
      grep = "grep --color=always";
      ssh = "ssh -Y -C";

      # Programs
      pdf = "evince";
      img = "eog";
      play = "celluloid";
      sl = "sl -ead -999";
      gvim = "nvim-qt"; 

      # System
      reboot = "read \\?\"Reboot? ENTER/Ctrl+C \" && env reboot";
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
      autoload -U colors && colors
      autoload -U compinit && compinit
      
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      _comp_options+=(globdots)


      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
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
   '';
  };

  home.sessionVariables = {
    NIX_CONFIG_DIR = "$HOME/NixOS";
    NIXPKGS_ALLOW_UNFREE = 1;
    TERM = "xterm-256color";
  };
 }

