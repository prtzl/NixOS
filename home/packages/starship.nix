{ homeArgs, ... }:

let
  personal = homeArgs ? personal && homeArgs.personal;
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
        error_symbol = "[»](bold red)";
        vicmd_symbol = "[«](bold blue)";
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
        disabled = false;
        format = "[:$path ]($style)";
        style = "bold cyan";
        truncate_to_repo = false;
        truncation_length = 5;
        truncation_symbol = ">";
      };
      git_branch = {
        style = "bold purple";
        format = "[$symbol$branch ]($style)";
        symbol = " ";
        always_show_remote = true;
      };
      git_commit = {
        disabled = true;
        only_detached = false;
        tag_disabled = false;
        tag_symbol = ":";
        format = "[\\($hash$tag\\)]($style)";
      };
      git_status = {
        ahead = "⇡($count)";
        behind = "⇣($count)";
        conflicted = "";
        deleted = "";
        disabled = false;
        diverged = "⇕⇡($ahead_count)⇣($behind_count)";
        format = "[\\[$all_status(|$ahead_behind)\\] ]($style)";
        modified = "󰷈";
        renamed = "";
        staged = "[++($count)](green)";
        stashed = "󰆧";
        style = " bold yellow";
        untracked = "";
        up_to_date = "✓";
      };
      nix_shell = {
        symbol = "❄️";
        style = "bold blue";
        format = "[$symbol  $name ]($style)";
      };
      c.disabled = true;
      cmake.disabled = true;
      cpp.disabled = true;
      package.disabled = true;
      python.disabled = true;
    };
  };
}
