{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = rec {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name=Numix-Cursor
      gtk-tooltip-timeout = 100
    '';
    gtk3.extraConfig.Settings = gtk2.extraConfig;
    gtk4.extraConfig = gtk3.extraConfig;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };
}
