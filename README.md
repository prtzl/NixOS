# NixOS configuration

This is my NixOS configuration repository.  
It houses system configuration files and user files managed by home-manager, which is installed by system.  
For longer explanation of how this works read [detailed instructions](./README_DETAILED.md).

## Install

First boot up NixOS minimal image and enter as root user.  

Run `./prepare-disk /dev/<DISK> <EFI/BIOS>` to parition and mount your drive.  

Install git and run everything from there: `nix-shell -p git`.  

Add nix channels:

```shell
./channels.sh
```

You will also want to add them after you're booted into your system.  

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

Now remove stock configuration files and replace them with a link to the repository configuration files. In my case, they are in `./system/<computer>/configuration.nix`.

```shell
cd /mnt/etc/nixos
rm *
ln -s /mnt/home/<username>/nixos/system/<computer>/configuration.nix .
```

Run install: `nixos-install`. Set temporary root password when asked.  

On first boot go to another tty and login as root with password you have entered. Using `passwd <user>` change root and your user passwords. Switch back to your GUI tty (tty7 for GNOME) and your user should appear.

## Wallpaper

I found it on internet some time ago, but it was bad quality. I turned it into vector image and exported 1080p and 1440p variants. If you find the author please thank him/her in my name.
