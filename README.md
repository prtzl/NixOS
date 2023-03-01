# NixOS configuration

This is my NixOS configuration repository.  
It contains system and user configuration files. System files in [system](./system) are used to build Nixos machine configurations and thus managing the state of the whole operating system.
Home files in [home](./home) are used to configure user applications and dotfiles managed by home-manager, which is installed either by system or manually on non-nixos platforms.  
More info on [nixos website](https://nixos.org).  
Old readme can be found [here](./README_DETAILED.md).

## Install Nixos

To install Nixos on a machine, follow the steps.  

Download minimal installation image for nixos from the [website](https://nixos.org/downloads) and create a bootable USB key.  

Boot up NixOS minimal image and switch to root user:
```shell
sudo su
```

Enter shell with git and run everything from there:
```shell
nix-shell -p git
```

Clone this repository:
```shell
git clone https://github.com/prtzl/nixos && cd nixos
```  

Use the script provided in the repository to format and partition and mount your main disk drive:
```shell
./prepare-disk /dev/<DISK> <EFI/BIOS>
``` 

Setup base nixos config on the mounted rootfs (in `/mnt`):
```shell
nixos-generate-config --root /mnt
```

You will find `configuration.nix` and `hardware-configuration.nix` in `/mnt/etc/nixos`.  
You can use these to identify and add flags and options for your system derivation.  

Create your new home directory, so that we can put this repository there:
```shell
mkdir -p /mnt/home/<username>
mv <path to cloned nixos repository> /mnt/home/<username>
```

Now remove stock configuration files by deleting directory `/etc/nixos` and replace it with a link to the git repository, with the same name.
```shell
rm -rf /mnt/etc/nixos
ln -s /mnt/home/<username>/nixos /mnt/etc/nixos
```

Install the system by entering the repository again and execute the following line:
```shell
nixos-install --flake .#<nixos-system-derivation>
```  

When the install is finished you will be asked to set a root password. I enter "root" and change it on the first boot.  

On first boot go to another tty (Ctrl+Alt+F<4?>) and login as root with password you have entered after install. Using `passwd <user>` change root and your user passwords:
```shell
passwd root
# Enter new root password

passwd <username>
# Enter new user password
```

Switch back to your GUI tty (tty7 for GNOME) and your user should appear in the menu.  

## Install Nix on non-Nixos system


On most distributions use the daemon install method:
```shell
sh <(curl -L https://nixos.org/nix/install) --daemon
```

On distributions using SELinux (fedora) you might either have to disable it (I don't care for it) or use the single user installer (this can result in some problems with shell configuration and other duplicate packages):
```shell
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

Do read up on the [website](https://nixos.org/download.html) for more info on the installers.

Now you're set! You can use nix in your shell. Check if it's working: `nix --version`.  

## Install home-manager on non-Nixos system

You can use nix and home-manager to manage your packages and configurations for user session. This way you can have the same set of user config files for Nixos and non-nixos systems.  
Since the user config is installed with Nixos config, this step will explain the procedure for non-Nixos systems.  

[home-manager](https://nix-community.github.io/home-manager/index.html) is used to manager your home/user configuration. To use it on nixos, just add it to the packages or as a module (I add it as a package so that it's separate from system config).  

To install home-manager on non-Nixos system, enter the following lines:
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

Once you're finished, it's time to replace default home-manager config, which is stored in `~/.config/nixpkgs` with the current repository path. Remove the nixpkgs folder and replace it with a link to the repo:
```shell
rm -rf ~/.config/nixpkgs
ln -s <path to this repo (absolute)> ~/config/nixpkgs
```

Since my config uses flake, which defines many different user session, we have to specify which. By default, home-manager sources `home.nix` from the path, but I don't have that there. We will need to use the option to source flake output, where the output represents a specific home user config. Since it's a flake, we can use `nix build` instead of `home-manager build`:
```shell
# In the repo
# This build my "matej-work" home derivation, which is used on my work laptop
nix build .#matej-work
```

The result of the build will be a `result`, which is a link to a build directory. Inside is a shell script, which will activate the new home configuration:
```shell
./result/activate
```

Hurray! In my case, `matej-work`, among other things, sets up dconf configuration for cinnamon desktop environment, which changes the theme, moves the status bar, changes background image, etc.  

To avoid typing this every time, I have a shell script installed globally with every home configuration. This way you'll need to do this step just once. See [maintenance](#maintenance) for more information.

## Maintenance

For maintenance of both system and home I created two scripts, each installed by their manager: `nixos-update` and `home-update`.  
Both scripts build the derivation, show the diff and ask for confirmation. System update requires sudo.  
Both scripts also accept option `-r`, which updates the flake lock file and thus does a system update instead of just rebuild.  
Other flags and options are passed on to the nix build command, excluding `-r` if present.  

You can also do it manually. System:

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
