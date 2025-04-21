{
  home.file.".profile".text = ''
    [ -f $HOME/.profile.uwsm ] && source $HOME/.profile.uwsm
  '';
}
