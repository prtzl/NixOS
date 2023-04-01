{ config, pkgs, homeArgs, ... }:

let
  personal = if homeArgs == null then true else homeArgs.personal;
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 50; # It's very noticable and anoying beyond this
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
        style_user = "bold yellow";
        format = "[$user]($style)";
      };
      hostname = {
        disabled = false;
        ssh_only = false;
        ssh_symbol = "  ";
        style = "bold " + (if personal then "green" else "blue");
        format = "[@$hostname$ssh_symbol]($style)";
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
      git_commit = {
        only_detached = false;
        tag_disabled = false;
        tag_symbol = ":";
        format = "[\\($hash$tag\\)]($style)";
      };
      git_status = {
        disabled = false;
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
        format = "[\\[$all_status$ahead_behind\\]]($style)";
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
}
