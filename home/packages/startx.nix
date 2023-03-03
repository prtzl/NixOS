{ desktop-environment, config, ... }:

{
  home.file.".startx.home".text = ''
    # Start DE on first session
    de=$(which ${desktop-environment})
    available=$?
    if [[ "$(tty)" = "/dev/tty1" && "$available" = "0" ]]; then
      pgrep ${desktop-environment} || startx
    fi
  '';

  home.file.".xinitrc".text = ''
    exec ${desktop-environment}
  '';
}
