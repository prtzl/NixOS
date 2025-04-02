{ pkgs, homeArgs, ... }:
# I guess I need fonts even when I installed them in the system. WHy!?
{
  # if (homeArgs ? notNixos && homeArgs.notNixos) then {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Noto Sans" ];
      sansSerif = [ "Noto Sans Serif" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  home.packages = with pkgs; [
    # don't install all fonts - takes time
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}
# } else
# { }
