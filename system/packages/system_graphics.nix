{ pkgs, modulesPath, ... }:

{
  # Rational is that every nixos supporting graphics (real PC, wsl) will also support audio
  imports =
    [ ./pipewire.nix (modulesPath + "/installer/scan/not-detected.nix") ];

  # DE of choice - unstable does not work, it does not boot, I don't know why
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };

  # services.displayManager.ly = { enable = true; };

  # Fixes electron apps in wayland, so I've read.
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  # I still don't know  what this is. It ran fine without, but I guess this is better?
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };
}
