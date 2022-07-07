#! /usr/bin/env sh

function peval()
{
    if ! eval "$@"; then
        echo Command: "$@" FAILED!
        exit 1
    fi
}

peval cd ~/NixOS
peval nix flake update
peval nixos-rebuild build --flake . --impure "$@"
peval nvd diff /run/current-system result
read -p "Perform switch (sudo)? [Y/n] " answer
if [[ "$answer" == [yY] ]]; then
    echo Applying update!
    peval sudo result/bin/switch-to-configuration switch
    peval sudo nix-collect-garbage -d
    echo Update finished!
else
    echo Update canceled!
fi
