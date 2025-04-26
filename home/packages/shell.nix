{
  home.file.".profile".text = ''
    for f in $(find ~/ -maxdepth 1 -name '.profile.*'); do
        [ -f $f ] && source $f;
    done
  '';
}
