#! /bin/sh
pushd $PWD/system
nixos-install -I nixos-config=./configuration.nix
popd
