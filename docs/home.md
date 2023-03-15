# home-manager for reproducible environment

[home-manager](https://nix-community.github.io/home-manager/index.html) is used to manager your home/user configuration. To use it on NixOS, just add it to the packages and configure it separately (that's how I do it) or as a module (is built and configured along with system).  

This way I write, configure, manage and install packages, their dependencies and dotfiles to correct locations. Some packages have Nix configurations build for them, which allows you to install configure a package with ease. Some don't have those, so I create my own config files, where a package (tmux) is installed into user session, and its dotfile is save into correct location (`~/.config/tmux/tmux.conf`).

## Install home-manager

If you have NixOS or NIX already installed, follow the steps.

```shell
# Replace "release-22.11" with the current release
nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
```

Here I used a stable branch as input for home-manager. To use unstable (rolling) replace the `release-22.11` with `master`.  
If you do not plan to install and configure shell with home manager then add the following line in your shell config (.bashrc or .zshrc ...):

```shell
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

If you plan to install and configure a shell (like zsh) with home-manager, then make sure to remove the existing package from your system (using apt or dnf or pacman).  

On non-nixos systems you might find, that your desktop environment does not find the applications managed by home-manager. That's because your profile does not find paths to the binaries and `.desktop` files. Add these two lines into your `~/.profile`:

```shell
export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
```

First line inserts nix profile paths at the beginning of existing `PATH`, and the second one adds the `.nix-profile/share` to the XDG directories path. `share` includes files like `.desktop`, icons, etc.  

zsh sources `~/.zprofile`, so add this line so that is sources `~/.profile` as well:
```shell
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
```

## Test your first configuration

home-manager, when installed, will create, build and apply a empty configuration. It is located in `~/.config/nixpkgs/home.nix`.

Let's add a package. Open `home.nix` and add these lines

```nix
home.packages = [
  pkgs.sl
];
```

You can build the home configuration by running `home-manager build` to check, if your config is fine (syntactically). To switch to the new configuration, run `home-manager switch`. Open a new terminal and type in `sl` (choo choo).

## Apply my configurations

My configurations are configured with flake in the same way as NixOS.

I remove the directory `~/.config/nixpkgs` and replace it with a link to this repository with the same name `nixpkgs`:

```shell
rm -rf ~/.config/nixpkgs
cd ~/.config
ln -s ../nixos nixpkgs
```

If you run `home-manager`, it won't find the file `home.nix`. To use configurations in flake, run:

```shell
# in my case, config for my home PC is called "matej-nixbox"
home-manager switch --flake ~/.config/nixpkgs#<home configuration>
```

You can also use `nix` commands to build and then apply new home configuration:

```shell
cd ~/.config/nixpkgs
nix build .#<home configuration>
./result/activate
```

The `activate` script will be available in `result` directory after a successful build.

## Maintenance

For maintenance I created a script, that builds the correct home configurations, shows the diff to the current one, then applies it and removes the `result` link. It is called [`home-update`](../home/packages/home_basic.nix).

The manual approach would be:

```shell
home-manager build --flake .#<home-derivation> # --impure
nvd diff /nix/var/nix/profiles/per-user/$USER/home-manager ./result
./result/activate
```

Run the manual approach at least once, so that the script and all environment variables become available.

The script searches for this repository in `/etc/nixos` and `~/.config/nixpkgs` in order. The paths are set with `NIX_FLAKE_DIR` and `NIX_FLAKE_DIR_HOME` in [`configuration_basic.nix`](../system/configuration_basic.nix) and [`home_basic.nix`](../home/home_basic.nix) respectively.  
Derivation for home is taken from value of `NIX_HOME_DERIVATION`, which is set in currently used `home.nix` (or equivalent). If this path or variable is not found, the following string `$USER-$(hostname)` will be used to select home derivation. Most of my derivations are named this way, but I still use environment variables first in cases, where the username or hostname is not practical to use for derivation name (work PC with domain set usernames and hostnames).
