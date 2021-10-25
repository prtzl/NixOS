# NixOS configuration

This is my "portable" NixOS configuration repository.  
It houses system configuration files and user files managed by home-manager, which is installed by system. 

## Installation

You can clone this repository wherever you want, preferably somewhere in your user home, for example: `/home/matej`.  
If you want to apply this configuration at first install, then follow the chapters.

### Boot installer

Download [NixOS live iso](https://nixos.org/download.html), minimal installation is more than enaugh, and burn it to a flash drive with capacity of at least 4GB. I recommend cross platform tool [balenaEtcher](https://www.balena.io/etcher/).  
Boot the usb and enter superuser: `sudo su`, no password will be required.

### Prepare destination drive

I have prepared a script that paritions the **WHOLE** selected drive and formats it for BIOS or EFI. Future options will come. The manual steps are described below.  

Currently I use EFI bootloader and ext4 filesystem. Use provided tool called `parted` to partition your disk.  
I use nvme ssd disk, therefore my disk path will be `/dev/nvme0n1`. Partition names for my disk will be `nvme0n1p1`, `nvme0n1p2`, etc.  
If you have ssd disk it might look like `/dev/sda` with partition names `/dev/sda1`, `/dev/sda2` etc.  

To create boot, swap and root partition, execute following lines on your drive location. **WARNING, THIS WILL WIPE ALL DATA ON THE DRIVE.**

```shell
parted /dev/<disk_name> -- mklabel gpt
parted /dev/<disk_name> -- mkpart ESP fat32 1MiB 512MiB
parted /dev/<disk_name> -- set 1 esp on
parted /dev/<disk_name> -- mkpart primary linux-swap 512MiB 2560MiB
parted /dev/<disk_name> -- mkpart primary 2560MiB 100%
```

In my case `<disk_name>` is `nvme0n1` and path: `/dev/nvme0n1`.  

Partitions will be numbered in order of these commands, therefore boot = 1, swap = 2, root = 3.  

**TIP:** If you label your partitions the same as me, you will be able to copy later commands and system configuration with no problem, as we'll be refering to each partition by its label and not **UUID**.  

To format and name(label) new partitions (use parition names, not drive name):

```shell
mkfs.fat -F 32 -n boot /dev/<disk_partition_1>
mkswap -L swap /dev/<disk_partition_1>
mkfs.ext4 -L nixos /dev/<disk_partition_1>
```

In my case `<disk_partition_{1,2,3}>` is `nvme0n1p{1,2,3}` and paths: `/dev/nvme0n1p{1,2,3}`.

Partitions are named as:

* /boot = boot
* [swap] = swap
* / = nixos

### Mount partitions

Mount main root partition (labeled third in steps above) to `/mnt`, create folder `/mnt/boot/efi` and mount boot partition to it. Enable swap.

```shell
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
```

### Manage configuration and install

To use the provided configuration from repository we will create our user folder in advance and clone the repository there. Use `nix-shell -p git` to download and enable git for this step.

```shell
mkdir -p /mnt/home/<your_user>
cd /mnt/home/<your_user>
nix-shell -p git
git clone https://github.com/prtzl/NixOS.git
exit
cd NixOS
```

For me `<your_user>` is `matej` and full path `/mnt/home/matej`.

We will still generate configuration just to observe settings in `/mnt/etc/nixos/hardware-configurations.nix`. Merge them into provided configurations from repository folder (NixOS): `system/bootloader.nix`, `system/filesystem.nix`.  

This is also the time to check the configuration. The main file is `system/configuration.nix`. In the beginning you can include or exclude other config files. You will also have to configure your user name, system application list, network card under networking and possibly more.  

I use GNOME with gdm. All GUI settings are in `system/graphics.nix` along with some gui applications. You can swap out window manager and desktop manager with the one you like. If you choose other desktop manager other than gnome, then you can exclude `users/matej/dconf.nix`, which only applies to gnome.

By default, running `nixos-install` would source `/mnt/etc/nixos/configuration.nix`. With option `-I nixos-config=<some_path>/configuration.nix` we can give it a path to our configuration. This is included in helper script:

```shell
./install-system.sh
```

If the installation was successfull it will ask for a root user password. Once set, reboot the system and remove the usb. You should be greeted by nixos bootloader.  
Once booted, (gdm) login window should appear. It will ask for a username. Your user, which was added in `system/configuration.nix` exists, but the password is not set yet. Enter another terminal with `ctrl+alt+F{1:6}` and login as `root` with previously set password. Set your user password:

```shell
passwd <your username>
```

Once entered, type `exit` and navigate back to GUI with `ctrl+alt+F7`. Now you should see your user available. Login with your set password.

### Install user configuration

Now you have a fresh install of nixos with stock GNOME and some basic tools and gui applications to get you running. To further configure your system we will use `home-manager`; a tool which was also included in system configuration. By default is sources configuration file in `~/.config/nixpgs/home.nix`. By using option `-f` we can use our own - those provided in the repository.  

First as with system configuration, please check out `users/matej/home.nix` for the configuration settings. You will have to change path to your user home folder along with applications you wish to have in the application list.
After tinkering with the list and other configuration files, you can "update" or in this case install user configuration for home manager with:

```shell
./apply-home.sh
```

It will now download, install and apply new settings. Things like theme, icons and shortcuts will all be available and applied after the installation is finished. However applications will be absent from the gnome application menu. Log out and log back in. There you have it.

## Maintenance

To update home configuration data, managed by `home-manager`, use `nix-channel --update`. This will only update the current (stable) channel information, much like `apt-get update`. You still need to apply it, like with `apt-get upgrade`.

```shell
./update-home.sh
./apply-home.sh
```

To update system configuration, use `sudo nix-channel --update`. You can use the script:

```shell
./update-system.sh
./apply-system.sh
```

If you wish, you can run all scripts one after another, starting with system update:

```shell
./update-install-all.sh
```

## Compatability

There are a few settings to keep an eye on when porting to a different machine:

* system/hardware-configuration.nix
  * Update list `boot.initrd.availableKernelModules` for your system
  * My system uses EFI bootloader with following partition names:
    * root (`/`) = "nixos"
    * swap = "swap"
    * boot (`/boot`) = "boot"
* system/configuration.nix:
  * Name the correct network interface under:

    ```shell
    networking.interfaces.enp<?>s0.useDHCP = true
    ```

Other parts of system configurations should be hardware agnostic. Of course don't forget to change username and git configuration!

## Wallpaper

I found it on internet some time ago, but it was bad quality. I turned it into vector image and exported 1080p and 1440p variants. If you find the author please thank him/her in my name.
