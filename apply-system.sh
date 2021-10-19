#! /bin/sh
pushd ~/NixOS/system
sudo nixos-rebuild switch -I nixos-config=./configuration.nix
popd
