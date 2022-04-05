{ config, pkgs, ... }:

{
  imports = [
    ./zsh_basic.nix
    ./dconf.nix
    ./alacritty.nix
    ./vscode.nix
    ./neovim.nix
  ];
  
  # Don't let home manager manage itself - by system config
  programs.home-manager.enable = true;
  
  # Packages
  home.packages = with pkgs; [

    # Latex
   # Fonts
    roboto

    # Extra
    #alock
  ];
  home.file.".background".source = ./wallpaper/tux-my-1440p.png;
  home.file.".lockscreen".source = ./wallpaper/lockscreen.png;

  xdg.configFile."libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
}

