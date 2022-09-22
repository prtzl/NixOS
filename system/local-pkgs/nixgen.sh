#! /usr/bin/env sh
set -e

function info()
{
	tput dim
	echo -e "${@}"
	tput sgr 0
}

function debug()
{
	tput setaf 3
	echo "${@}"
	tput sgr 0
}

function error()
{
	tput setaf 1 >&2
	echo -e "${@}" >&2
	tput sgr 0 >&2
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

help="Diff between two system configs
Command: nixgen GEN(nix_now) NEW(./result)
    GEN:
        nix_hm:   home-manager
        nix_boot: new system
        nix_now:  current system
    NEW: nix build directory"

gen=${1:-nix_now}
new_dir=${2:-./result}

# Check if first argument is an option
if [[ $1 = --* || $1 = -* ]]; then
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        info "$help"
        exit 0
    fi
    info "$help"
    exit 0
fi

# Check for $new directory
if [ ! -d $new_dir ]; then
    fatal "New build directory path invalid or missing!"
fi

# Possible generations
nix_hm="/nix/var/nix/profiles/per-user/$USER/home-manager"
nix_now="/run/current-system"
nix_boot="/nix/var/nix/profiles/system"

# Check for generation
case $gen in
    nix_hm) old_dir=$nix_hm;;
    nix_boot) old_dir=$nix_boot;;
    nix_now) old_dir=$nix_now;;
    *) error "Invalid generation option!"; info "$help"; fatal;;
esac

# Finaly execute diff
nvd diff $old_dir $new_dir
