{ config, pkgs, ... }:

let
  stm32cubemx-override = pkgs.stm32cubemx.overrideAttrs (oldAttrs: rec {
    version = "6.6.1";
    src = pkgs.fetchzip {
      url = "https://sw-center.st.com/packs/resource/library/stm32cube_mx_v${builtins.replaceStrings ["."] [""] version}-lin.zip";
      sha256 = "sha256-NfJMXHQ7JXzRSdOAYfx2t0xsi/w2S5FK3NovcsDOi+E=";
      stripRoot = false;
    };
  });
in {
  imports = [
    ../home_basic.nix
  ];

  # Packages
  home.packages = with pkgs; [

    # Dev
    jetbrains.clion
    jetbrains.pycharm-community
    gcc-arm-embedded
    gcc
    clang-tools
    gnumake
    cmake
    stm32cubemx-override

    # Content creation
    audacity
    gimp
    obs-studio

    # Games
    steam
    #minecraft
  ];
}

