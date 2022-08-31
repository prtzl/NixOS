# NixOS configuration

This is my NixOS configuration repository.  
It houses system configuration files and user files managed by home-manager, which is installed by system (or manualy on non-nixos platforms).  
For longer explanation of how this works read [detailed instructions](./README_DETAILED.md).

## Install

First boot up NixOS minimal image and enter as root user.  

Run `./prepare-disk /dev/<DISK> <EFI/BIOS>` to parition and mount your drive.  

Install git and run everything from there: `nix-shell -p git`.  

Setup nixos:

```shell
nixos-generate-config --root /mnt
```

You will find `configuration.nix` and `hardware-configuration.nix` in `/mnt/etc/nixos`. 
You can use these to add flags for your system.  

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

Install the system by entering the repository and building the system flake: `nixos-rebuild build --flake .#<nixos-system-derivation>`.  
If the build goes without problems, switch the system to the flake: `nixos-rebuild switch --flake .#<nixos-system-derivation>`.  

On first boot go to another tty and login as root with password you have entered. Using `passwd <user>` change root and your user passwords. Switch back to your GUI tty (tty7 for GNOME) and your user should appear.  

After installation, remove the default home-manager directory in `~/.config/nixpkgs` and replace it with a link to the git repository with the same name.  

## Wallpaper

I found it on internet some time ago, but it was bad quality. I turned it into vector image and exported 1080p and 1440p variants. If you find the author please thank him/her in my name.

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
