#! /usr/bin/env sh

function peval()
{
    if ! eval "$@"; then
        echo Command: "$@" FAILED!
        exit 1
    fi
}

flake=$(id -un)-$(hostname)

peval cd /etc/nixos
peval nix flake update
peval home-manager build --flake .\#$flake --impure "$@"
peval nvd diff $HOME/.nix-profile result
read -p "Perform switch? [Y/n] " answer
if [[ "$answer" == [yY] ]]; then
    echo Applying update!
    peval home-manager switch --flake .\#$flake --impure "$@"
    # new derivation is applied but not after reboot - ?
    # peval sudo result/bin/switch-to-configuration switch
    peval rm result
    #peval sudo nix-collect-garbage -d
    echo Update finished!
else
    echo Update canceled!
fi
