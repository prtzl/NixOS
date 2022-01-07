#! /usr/bin/env sh
sudo nix-channel --add https://nixos.org/channels/nixos-21.11 nixos-21.11
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update
