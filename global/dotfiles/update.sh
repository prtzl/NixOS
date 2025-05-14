#!/usr/bin/env bash

set -e

function info()
{
	tput dim
	echo "${@}"
	tput sgr 0
}

function warn()
{
	tput setaf 3 >&2
	echo "${@}" >&2
	tput sgr 0 >&2
}

function error()
{
	tput setaf 1 >&2
	echo -e "${@}" >&2
	tput sgr 0 >&2
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
    [ -f "$1"/flake.nix ]
}

function cleanup()
{
    rm -f $out_link
}

## Boilerplate finished

home_derivation="$USER-$(hostname)"
nixos_derivation="$(hostname)"


# First argument is build type and should only be home or nixos.
# With this define main build, diff, and switch implementation functions
derivation_type=$1
if [[ "$derivation_type" == "home" ]]; then
    out_link="/tmp/home-build-result"
    derivation="homeConfigurations.${home_derivation}.activation-script"
    profile_path="$HOME/.local/state/nix/profiles/home-manager"

    function derivation_apply()
    {
        if ! peval "${out_link}"/activate; then
            cleanup
            fatal "Failed to activate!"
        fi
    }
elif [[ "$derivation_type" == "nixos" ]]; then
    out_link="/tmp/nixos-build-result"
    derivation="nixosConfigurations.${nixos_derivation}.config.system.build.toplevel"
    profile_path="/run/current-system"

    function derivation_apply()
    {
        if ! (peval sudo nix-env --profile /nix/var/nix/profiles/system --set "$out_link" \
            && peval sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch); then

            warn "Manual switch failed, falling back to nixos-rebuild"
            if ! peval sudo nixos-rebuild switch --flake .\#"${nixos_derivation}" "${ARGS[@]}"; then
                cleanup
            fatal "Failed to activate!"
            fi
        fi
    }
else
    fatal "Choose home or nixos for first argument!"
fi


# Made generic with "profile_path" variable
function derivation_diff()
{
    if [ -e "$profile_path" ]; then
        peval nvd diff "$(readlink -f "$profile_path")" "$(readlink -f "$out_link")"
    else
        info "No existing profile found to diff against."
    fi
}

# Made generic with "derivation" variable
function derivation_build()
{
    peval nix build .\#"$derivation" --out-link "$out_link" "${ARGS[@]}"
}


# Check for global variables (set by derivation project)
# If not set, then use default paths depending on home or nixos build
if checkForFlake "$NIX_FLAKE_DIR"; then
    flake_dir="$NIX_FLAKE_DIR"
elif checkForFlake "$NIX_FLAKE_DIR_HOME"; then
    flake_dir="$NIX_FLAKE_DIR_HOME"
elif [[ "$derivation_type" == "home" ]]; then
    flake_dir="$HOME/.config/nixpkgs"
elif [[ "$derivation_type" == "nixos" ]]; then
    flake_dir="/etc/nixos"
fi

# Remove arguments ment for this script and only pass ARGS to other tools
declare -a ARGS
update_flake_lock="false"
for var in "$@"; do
    if [[ "$var" == "-r" ]]; then
        update_flake_lock="true"
        continue;
    elif [[ "$var" == "$derivation_type" ]]; then
        continue;
    elif [[ "$var" = "-h" || "$var" == "--help" ]]; then
        info "This script updates lock file, builds derivation, shows update diff and applies it.\nAdd option '-r' to skip lock file update (just rebuild)."
        exit 0
    fi
    ARGS[${#ARGS[@]}]="$var";
done


peval cd "$flake_dir"
if [[ "$update_flake_lock" == "true" ]]; then
    info "Updating flake.lock!"
    peval nix flake update
fi


info "Building derivation: ${derivation_type}!"
derivation_build

info "Diffing generation with current:"
derivation_diff


read -r -p "Perform switch? [y/Y] " answer
if [[ "$answer" == [yY] ]]; then
    info Applying update!
    derivation_apply
    info Update finished!
else
    info Update canceled!
fi

cleanup
