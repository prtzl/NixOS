# yes yes, this is also installed in system base. That one just doesn't have customizations
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "flat-remix";
      presets = "cpu:0:default,mem:0:tty,proc:1:default cpu:0:braille,proc:0:tty";
      proc_gradient = false;
      disks_filter = "exclude=/boot";
      swap_disk = false; # don't show swap disk, but swap usage will still be used
    };
  };
}
