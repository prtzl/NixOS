# NixOS installation

This readme outlines the procedure, with which you can install NixOS on your PC.  
The procedure is configuration agnostic up until a certain point. This is where I'll branch into a "beginner" approach, which is the default, and my approach using my config.  

## Boot NixOS installer

Download minimal installation image for nixos from the [website](https://nixos.org/downloads). Nowdays, graphical installation images are available as well to test things around. Either way, installation steps will be performed in a terminal.  

Find a USB key with at least 8GB of space and use a flashing utility, like [Balena](https://www.balena.io/etcher) to flash the downloaded image onto the USB key.  

Backup any data on the computer, that you're about to re-flash with NixOS, since the procedure wipes the main disk clean.  
Follow your PC manufacturer's instructions to figure out how to enter the boot menu on power-up. Once the menu is opened, choose your USB and wait for the NixOS installer image to boot. If you're using GUI installer, you will probably be booting straight to a desktop. With minimal installer, you will be presented with terminal window logged in as `nixos` user.  

## Preparation for installation

If you chose graphical installer, open a terminal. From this point on, both ways are the same.  

Switch to the root user by typing:

```shell
sudo su
```

Nix relies on git for fetching configurations, even built-in. Let's launch a temporary shell, that has git available:

```shell
nix-shell -p git
```

You will notice that the shell changed color. Now, `git` command is available.

## Prepare disk driver

To ease the preparation of your boot disk, download this repository to the installer home directory:

```shell
git clone https://github.com/prtzl/nixos && cd nixos
```

Now we're launching `prepare-disk.sh` script to wipe, partition and format disk partitions.  
The arguments, that you need to provide to the script, are as follows:

```shell
./prepare-disk /dev/<DISK> <EFI/BIOS>
```

Time to figure out your disk path, that you want. Use command `lsblk` to list all the disks plugged in.  
If you're using a standard SDD disk, your disk path might look like `/dev/sda`, where letter **"a"** could be any other in case you have multiple solid state driver plugged into your computer. Using previous command output, select the one that you with to use.  
In case of an NVME disk, your disk name might look something like `nvme0n1`, where last number, in this case **"1"**, changes depending on the amount of NVME disks plugged into your computer.

This script still supports creating the "legacy" BIOS boot mode, but nowdays, EFI is used almost exclusively. My configurations would have to be changed if I wanted to use BIOS, so this option is just here for backup.
Once the script is finished, you can verify that the filesystem looks OK. Run `lsblk` again and check if you have 3 partitions created and formatted.  
The name of partitions change between SDD and NVME disks. SSD disks will create new devices with the number of the partition added to the end of the disk name. For example `/dev/sda1` for first partition.  
On NVME disks partitions are named with "pN" added to the end of the disk path, where the number identifies a particular partition. For example: `/dev/nvme0n1p1`.

This script does the following:
* format disk,
* create ESP boot partition with size of 512MB,
* create swap partition with 2GB of space,
* create root partition with the remaining space,
* format boot partition as fat32 and name it "boot",
* format swap partition,
* format root partition as ext4 and name it "nixos",
* mount root partition to `/mnt`,
* create directories `/boot/efi` on the mounted disk and mount boot partition to it,
* enable swap

Please make sure to check if everything is formatted and mounted correctly using `lsblk`.

## Start NixOS configuration

Now that the disk is prepared, let's start the configuration. NixOS provides a command to initialize configuration for your machine.  
Run the following command:

```shell
nixos-generate-config --root /mnt
```

Remember, our disk is mounted to `/mnt`, so every path will begin with `/mnt` and not straight from `/`, which is filesystem of the bootable USB key.

In our case, since the target disk root is mounted in `/mnt`, this will create a directory with two files in `/mnt/etc/nixos`:
* configuration.nix
* hardware-configuration.nix

These two files include minimal settings, some particular to your machine (hardware), that you need to build the system.  
At this point, the general procedure and my configuration change path. From this point on, you may use the two provided files to configure your system. Make sure to read the NixOS documentation. You can also clone your own configuration repository and extract the files in `/mnt/etc/nixos` to apply your configuration much more easily. That said, this approach, including mine (in next chapter) works for single user nixos configuration, which might be fine, since NixOS should only configure global system and not any user level config.

So, if you're not applying my workflow/configuration from this repository, feel free to skip the next chapter to get to the install phase.

## Apply my configuration

My workflow, both for NixOS and non-NixOS platforms, is to have this repository stored in `/home/$USER/nixos`. Then by creating links for this folder to `/etc/nixos` and/or `/home/$USER/.config/nixpkgs` you can use `nixos-rebuild` command to build my systems.

Create your user directory in advance (in case of multi user configuration, this would be the maintainer) so we can put the repository there.

```shell
# In my case, username is "matej" and path to this repo, if you followed the instructions, should be in `/home/nixos/nixos`
mkdir -p /mnt/home/<username>
mv <path to this repository> /mnt/home/<username>

```

Now remove stock configuration files by deleting directory `/etc/nixos` and replace it with a link to the configuration repository. Link has to have the same name `nixos`.
```shell
cd /mnt/etc
rm -rf nixos
ln -s ../home/<username>/nixos nixos
```

Now we're ready to launch the installer.

## Install Nixos

NixOS installer will look for `/mnt/etc/nixos/configuration.nix` or a flake in the same directory location. To run installer, run:

```shell
# In case of configuration.nix
cd /mnt
nixos-install

# In case of a flake with multiple configurations/NixOS outputs (this repo) 
# In my case, my main PC uses configuration "nixbox". I also need to add "--impure" option
cd /mnt/etc/nixos
nixos-install --flake .#<nixos configuration> --impure
```

When the install is finished you will be asked to set a root password. I enter "root" and change it later.  
On first boot go to another tty (Ctrl+Alt+F<4?>) and login as root with password you have entered after install (root). Change root and your user passwords:

```shell
passwd root
# Enter new root password

passwd <username>
# Enter new user password
```

Switch back to your GUI tty (tty7 for GNOME) and your user should appear in the menu.

## Maintenance

For maintenance I created a script, that builds the correct system configuration, shows the diff to the current one, then applies it and removes the `result` link. It is called [`nixos-update`](../system/packages/local-pkgs/nixos-update.sh).

The manual approach would be:

```shell
cd <nixos repository>
# System
nixos-rebuild build --flake .#<system-derivation>
nvd diff /run/current-system ./result

# Either or, testing for now:
sudo nixos-rebuild switch --flake .#<system-derivation>
rm ./result
```

Run the manual approach at least once, so that the script becomes available.

The script searches for this repository in `/etc/nixos` and `~/.config/nixpkgs` in order. The paths are set with `NIX_FLAKE_DIR` and `NIX_FLAKE_DIR_HOME` in [`configuration_basic.nix`](../system/configuration_basic.nix) and [`home_basic.nix`](../home/home_basic.nix) respectively.  
Derivation for system is chosen by hostname value `$(hostname)`. This is how I name all my NixOS configurations.
