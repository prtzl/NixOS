{ pkgs, lib, systemArgs, homeArgs, ... }:

lib.mkMerge [
  ({
    fonts = lib.mkMerge [
      ({
        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [ "Noto Serif" ];
            sansSerif = [ "Noto Sans" ];
            monospace = [ "FiraCode Nerd Font" ];
          };
        };
      })
      (if (systemArgs ? isSystem && systemArgs.isSystem) then ({
        fontDir.enable = true;
        packages = with pkgs; [
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
        ];
      }) else
        { })
    ];
  })
  (if (homeArgs ? isHome && homeArgs.isHome) then ({
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  }) else
    { })
]
