{ desktop-environment, ... }:

{
  home.file.".startx.home".text = ''
    # Start DE on first session
    de=$(which ${desktop-environment})
    available=$?
    if [[ "$(tty)" = "/dev/tty1" && "$available" = "0" && -z "''${DISPLAY}" ]]; then
      pgrep ${desktop-environment} || exec startx
    fi
  '';

  home.file.".xinitrc".text = ''
    exec ${desktop-environment}
  '';
}
