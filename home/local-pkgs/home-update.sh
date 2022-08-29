#! /usr/bin/env sh

function peval()
{
    if ! eval "$@"; then
        echo Command: "$@" FAILED!
        exit 1
    fi
}

# Default location - for me, /etc/nixos is a symlink to git repository
flake_dir=/etc/nixos
home_derivation=$USER-$(hostname)

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
peval home-manager build --flake .\#$home_derivation --impure "$ARGS"
peval nvd diff /nix/var/nix/profiles/per-user/$USER/home-manager result
read -p "Perform switch? [y/Y] " answer
if [[ "$answer" == [yY] ]]; then
    echo Applying update!
    peval ./result/activate
    echo Update finished!
else
    echo Update canceled!
fi
peval rm result