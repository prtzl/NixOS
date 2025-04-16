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

# The rule is to name system derivation after hostname
system_derivation=$(hostname)

# Flake for nixos is always defined by variable or default in /etc/nixos
flake_dir=${NIX_FLAKE_DIR:-"/etc/nixos"}

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
peval nix build .\#${system_derivation} "$ARGS"
peval nvd diff /run/current-system result

read -p "Perform switch? [y/Y] (sudo)" answer
if [[ "$answer" == [yY] ]]; then
    info Applying update!

    if ! (peval sudo nix-env --profile /nix/var/nix/profiles/system --set ./result \
        && peval sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch); then

        warn "Manual switch failed, falling back to nixos-rebuild"
        if ! peval sudo nixos-rebuild switch --flake .\#${system_derivation} $ARGS; then
            rm result
        fatal "Failed to activate!"
        fi
    fi

    info Update finished!
else
    info Update canceled!
fi
peval rm result
