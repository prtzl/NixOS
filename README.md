# NixOS configuration

This is my NixOS configuration repository.  
It houses system configuration files and user files managed by home-manager, which is installed by system (or manualy on non-nixos platforms).  
For longer explanation of how this works read [detailed instructions](./README_DETAILED.md).  
More info on [nixos website](https://nixos.org).

## Install nixos

First boot up NixOS minimal image and switch to root user: `sudo su`.  
Enter shell with git and run everything from there: `nix-shell -p git`.  
Clone and enter his repository: `git clone https://github.com/prtzl/NixOS && cd NixOS`.  
Run `./prepare-disk /dev/<DISK> <EFI/BIOS>` to parition and mount your drive.  

Setup nixos:

```shell
nixos-generate-config --root /mnt
```

You will find `configuration.nix` and `hardware-configuration.nix` in `/mnt/etc/nixos`.  
You can use these to add flags for your system derivation.  

Create your new home directory, so that we can put this repository there:

```shell
mkdir -p /mnt/home/<username>
mv <path to cloned nixos repository> /mnt/home/<username>
```

Now remove stock configuration files by deleting directory `/etc/nixos` and replace it with a link to the git repository, with the same name.

```shell
rm -rf /mnt/etc/nixos
ln -s /mnt/home/<username>/NixOS /mnt/etc/nixos
```

Install the system by entering the repository:

```shell
nixos-install --flake .#<nixos-system-derivation>
```  

When the install is finished you will be asked to set a root password. I enter "root" and change it on the first boot.  

On first boot go to another tty and login as root with password you have entered after install. Using `passwd <user>` change root and your user passwords. Switch back to your GUI tty (tty7 for GNOME) and your user should appear.  

## Install home configuration

You can use nix and home-manager as built tool and to manage your packages and configurations.  

On most distributions use the daemon install method:

```shell
sh <(curl -L https://nixos.org/nix/install) --daemon
```

On distributions using SELinux (fedora) you might either have to disable it (do share a better solution for multi user setup) or use the single user installer:

```shell
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

Do read up on the [website](https://nixos.org/download.html) for more info on the installers.

Now you're set! You can use nix in your shell. Check if it's working: `nix --version`.  

[home-manager](https://nix-community.github.io/home-manager/index.html) is used to manager your home/user configuration. To use it on nixos, just add it to the packages or as a module (I add it as a package so that it's separate from system config).  

To install home-manager enter the following lines:

```shell
nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
```

Here I used a stable branch as input for home-manager. To use unstable (rolling) replace the `release-22.05` with `master`.  
If you do not plan to install and configure shell with home manager then add the following line in your shell config (.bashrc or .zshrc ...):

```shell
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

If you plan to install and configure a shell (like zsh) with home-manager then make sure to remove the existing pacakge from your system.  

On non-nixos systems you might find, that your desktop environment does not find the applications managed by home-manager. That's because your profile does not find paths to the binaries and `.desktop` files. Add these two lines into your `~/.profile`:

```shell
export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
```

First line inserts nix profile paths at the beginning of existing `PATH`, and the second one adds the `.nix-profile/share` to the XDG directories path. `share` includes files like `.desktop`, icons, etc.

## Maintenance

For maintenance of both system and home I created two scripts, each installed by their manager: `nixos-update` and `home-update`.  
Both scripts build the derivation, show the diff and ask for confirmation. System update requires sudo.  
Both scripts also accept option `-r`, which updates the flake lock file and thus does a system update instead of just rebuild.  
Other flags and options are passed on to the nix build command, excluding `-r` if present.  

You can also do it manualy. System:

```shell
cd <nixos repository>
# System
nixos-rebuild build --flake .#<system-derivation>
nvd diff /run/current-system ./result

# Either or, testing for now:
sudo nixos-rebuild switch --flake .#<system-derivation>
sudo ./result/bin/switch-to-configuration switch
rm ./result
```

Home:

```shell
home-manager build --flake .#<home-derivation> # --impure
nvd diff /nix/var/nix/profiles/per-user/$USER/home-manager ./result

# Either or, testing for now
./result/activate
home-manager switch --flake .#<home-derivation> # --impure
```

Both script search for the flake repository in `/etc/nixos` and `~/.config/nixpkgs` in the same order. The paths are set with `NIX_FLAKE_DIR` and `NIX_FLAKE_DIR_HOME` in `system/configuration_basic.nix` and `home/home_basic.nix` respectively.  
Derivation for system and home is taken from value of `NIX_SYSTEM_DERIVATION` and `NIX_HOME_DERIVATION`, which are set in currently used `configuration.nix` and `home.nix`. If not, `$(hostname)` will be used to select system derivation and `$USER-$(hostname)` will be used for home derivation. My derivations are named this way, but I still use environment variables first.

## Wallpaper

I found it on internet some time ago, but it was bad quality. I turned it into vector image and exported 1080p and 1440p variants. If you find the author please thank him/her in my name.
