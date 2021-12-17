{ config, ... }:

{
  programs.zsh = {
    shellAliases = {
      # Manage updating
      aps = "sudo nixos-rebuild switch -I nixos-config=$NIX_CONFIG_DIR/system/nixbox/configuration.nix";
      aph = "home-manager switch -f $NIX_CONFIG_DIR/home/nixbox/home.nix";
    };
  };
}
