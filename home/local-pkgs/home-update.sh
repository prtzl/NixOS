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

# Find where the flake is: git folder link to /etc/nixos or ~/.config/nixpkgs
if checkForFlake "$NIX_FLAKE_DIR"; then
    flake_dir="$NIX_FLAKE_DIR"
elif checkForFlake "$NIX_FLAKE_DIR_HOME"; then
    flake_dir="$NIX_FLAKE_DIR_HOME"
else
    info "No flake dir found in NIX_FLAKE_DIR or NIX_FLAKE_DIR_HOME"
    exit 1
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
peval home-manager build --flake .\#"$home_derivation" --impure "$ARGS"
peval nvd diff /nix/var/nix/profiles/per-user/$USER/home-manager result
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
peval rm result
