{ ... }:

{
  home.file.".config/dunst/dunstrc".text = ''
    [global]
      origin = top-center
      alignment = center
      notification_limit = 3
      offset = (0, 10)
      separator_height = 1
      font = FiraCode 18
      width = (0, 800)
      height = (0, 300)
      progress_bar_height = 30
      format = "<b>%s - %a</b>\n%b"
      vertical_alignment = "center"
      stack_duplicates = true

    [volume]
      appname = volume
      timeout = 1

    [urgency_low]
      timeout = 5

    [urgency_normal]
      timeout = 5

    [urgency_critical]
      timeout = 5
  '';
}
