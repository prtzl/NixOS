#! /usr/bin/env sh

function peval()
{
    if ! eval "$@"; then
        exit 1
    fi
}

peval cd ~/NixOS
peval nix flake update
peval nixos-rebuild build --flake . --impure "$@"
peval nvd diff /run/current-system result
read -s -p "Perform switch? (sudo)" answer
if [[ "$answer" == [yY] ]]; then
	peval sudo result/bin/switch-to-configuration switch
fi
