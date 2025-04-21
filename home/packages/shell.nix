{
  home.file.".profile".text = ''
    if [[ -e $HOME/.profile.uwsm ]] source $HOME/.profile.uwsm
  '';
}
