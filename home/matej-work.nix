# TODO: fix this to match other derivations, figure out cinnamon config as well
{ pkgs, config, ... }:

let
  # Create package path
  p = package: (./. + ("/packages/" + "${package}"));
  # Import a package with extra args
  pp = { package, ... }@args:
    (let path = ./. + ("/packages/" + "${package}");
    in import "${path}" (args // { inherit pkgs config; }));
in {
  imports = [
    (p "home_basic.nix")
    (p "nvim.nix")
    (p "tio.nix")
    (p "tmux.nix")
    (p "ranger.nix")
    (p "dconf.nix")
    (p "fonts.nix")
    (p "zsh.nix")
    (p "alacritty.nix")
    (p "redshift.nix")
    (pp {
      package = "startx.nix";
      desktop-environment = "cinnamon-session";
    })
  ];

  home.username = "mblagsic";
  home.homeDirectory = "/home/mblagsic";

  # Packages
  home.packages = with pkgs; [
    stm32cubemx
    podman
    fuse-overlayfs

    # Media
    gimp
    libreoffice
    unstable.evince
    gnome.gnome-screenshot

    # Documents
    texlive.combined.scheme-full
    texstudio

    # Online
    firefox
    chromium
    enpass
    transmission-gtk

    # Communication
    skypeforlinux
    unstable.signal-desktop-beta
    unstable.discord
    remmina

    # Other
    nixgl.nixGLIntel
  ];

  # Non-nixos openGL patched programs
  programs.alacritty.package = pkgs.glWrapIntel { pkg = pkgs.alacritty; };
  programs.kitty.package = pkgs.glWrapIntel { pkg = pkgs.kitty; };
}
