#! /usr/bin/env sh

function peval()
{
    if ! eval "$@"; then
        echo Command: "$@" FAILED!
        rm ./result
        exit 1
    fi
}

function checkForFlake()
{
    [ -f $1/flake.nix ]
}

# Default location - for me, /etc/nixos is a symlink to git repository
if [[ -z "$NIX_HOME_DERIVATION" ]]; then
    system_derivation=$USER-$(hostname)
else
    system_derivation="$NIX_HOME_DERIVATION"
fi

# Find where the flake is: git folder link to /etc/nixos or ~/.config/nixpkgs
if checkForFlake "$NIX_FLAKE_DIR"; then
    flake_dir="$NIX_FLAKE_DIR"
elif checkForFlake "$NIX_FLAKE_DIR_HOME"; then
    flake_dir="$NIX_FLAKE_DIR_HOME"
else
    echo "No flake dir found in NIX_FLAKE_DIR or NIX_FLAKE_DIR_HOME"
    exit 1
fi

# Remove arguments ment for this script and only pass ARGS to other tools
declare -a ARGS
for var in "$@"; do
    if [[ "$var" == "-r" ]]; then
        update_flake_lock="true"
        continue;
    elif [[ "$var" = "-h" || "$var" == "--help" ]]; then
        echo "This script updates lock file, builds derivation, shows update diff and applies it.\nAdd option '-r' to skip lock file update (just rebuild)."
        exit 0
    fi
    ARGS[${#ARGS[@]}]="$var"
done

peval cd $flake_dir
if [[ "$update_flake_lock" == "true" ]]; then
    echo "Updating flake.lock!"
    peval nix flake update
fi

echo "Building derivation!"
peval nixos-rebuild build --flake .\#${system_derivation} "$ARGS"
peval nvd diff /run/current-system result
read -p "Perform switch? [y/Y] (sudo)" answer
if [[ "$answer" == [yY] ]]; then
    echo Applying update!
    # this shit still does not not enter the derivation into /nix/var/nix/profiles - no changes after reboot
    #peval sudo ./result/bin/switch-to-configuration switch
    sudo nixos-rebuild switch --flake .\#${system_derivation} $ARGS
    echo Update finished!
else
    echo Update canceled!
fi
peval rm result
