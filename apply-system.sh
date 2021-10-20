#! /bin/sh
pushd $PWD/system
sudo nixos-rebuild switch -I nixos-config=./configuration.nix
popd
