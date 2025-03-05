#! /usr/bin/env sh
set -e

function info()
{
	tput dim
	echo "${@}"
	tput sgr 0
}

function debug()
{
	tput setaf 3
	echo "${@}"
	tput sgr 0
}

function fatal()
{
	error "$@"
	exit 1
}

function peval()
{
	info "$@"
	eval "$*"
}

function checkForFlake()
{
    [ -f $1/flake.nix ]
}

# Default location - for me, /etc/nixos is a symlink to git repository
home_derivation=${NIX_HOME_DERIVATION:-$USER-$(hostname)}

# Check for flake dir in nixos or non-nixos variables, else default in ~/.config/nixpkgs
if checkForFlake "$NIX_FLAKE_DIR"; then
    flake_dir="$NIX_FLAKE_DIR"
    system="nixos"
elif checkForFlake "$NIX_FLAKE_DIR_HOME"; then
    flake_dir="$NIX_FLAKE_DIR_HOME"
else
    flake_dir="$HOME/.config/nixpkgs"
fi

# Remove arguments ment for this script and only pass ARGS to other tools
declare -a ARGS
for var in "$@"; do
    if [[ "$var" == "-r" ]]; then
        update_flake_lock="true"
        continue;
    elif [[ "$var" = "-h" || "$var" == "--help" ]]; then
        info "This script updates lock file, builds derivation, shows update diff and applies it.\nAdd option '-r' to skip lock file update (just rebuild)."
        exit 0
    fi
    ARGS[${#ARGS[@]}]="$var"
done

peval cd $flake_dir
if [[ "$update_flake_lock" == "true" ]]; then
    info "Updating flake.lock!"
    peval nix flake update
fi

info "Building derivation!"
peval nix build .\#"$home_derivation" --impure "$ARGS"

path=/nix/var/nix/profiles/per-user/$USER/profile
if [ -f $path ]; then
    peval nvd diff $path result
fi

read -p "Perform switch? [y/Y] " answer
if [[ "$answer" == [yY] ]]; then
    info Applying update!
    if ! peval ./result/activate; then
        rm result
        fatal "Failed to activate!"
    fi
    info Update finished!
else
    info Update canceled!
fi
peval rm -f result
