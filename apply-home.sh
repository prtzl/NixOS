#! /bin/sh
pushd $PWD/users/matej
home-manager switch -f ./home.nix
popd
