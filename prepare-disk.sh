#! /bin/sh
pushd $PWD

# Find disk by full path from prompt
DISK=$1
if [ -z $DISK ]; then
    echo "Missing argument: disk path"
    exit
fi
res=$(find /dev -wholename $DISK)
if [ -z $res ]; then
    echo "Invalid disk sellected"
    exit
fi
echo Selected disk: $DISK

# Get partition name prefix (before partition number)
PART=""
if [ $DISK == /dev/sd[a-z] ]; then
    echo "Disk type is SD"
    PART=${DISK}
elif [ $DISK == /dev/nvme0n[1-9] ]; then
    echo "Disk type is NVME"
    PART=${DISK}p
elif [ $DISK == /dev/vd[a-z] ]; then
    echo "Disk type is VD"
    PART=${DISK}
else
    echo "Disk type could not be deducted, supported: sd[a-z], nvme0n[a-z], vd[a-z]"
    exit
fi

# Get partition table information
BOOT=$2
if [ -z $BOOT ]; then
    echo "Select EFI or BIOS"
    exit
elif [ $BOOT == "EFI" ]; then
    echo "Selected EFI partition"
elif [ $BOOT == "BIOS" ]; then
    echo "Selected BIOS partition"
else
    echo "Invalid partition selection: EFI or BIOS"
    exit
fi

# Partition disk functions
# EFI
partitionEfi()
{
    parted -s $DISK -- mklabel gpt
    parted -s $DISK -- mkpart ESP fat32 1MB 512MB
    parted -s $DISK -- mkpart primary linux-swap 512MB 4608MB
    parted -s $DISK -- mkpart primary 4608MB 100%
    parted -s $DISK -- set 1 esp on
    # Format
    mkfs.fat -F 32 -n boot ${PART}1
    mkswap -L swap ${PART}2
    mkfs.ext4 -L nixos ${PART}3
    # Mount and enable swap
    mount ${PART}3 /mnt
    mount --mkdir ${PART}1 /mnt/boot
    swapon ${PART}2

    # Saw it somewhere - maybe solves vm issues
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars
}
# BIOS
partitionBios()
{
    parted -s $DISK mklabel msdos
    parted -s $DISK mkpart primary linux-swap 1MiB 512MiB
    parted -s $DISK mkpart primary 512MiB 100%
    # Format
    mkswap -L swap ${PART}1
    mkfs.ext4 -L nixos ${PART}2
    # Mount and enable swap
    mount /dev/disk/by-label/nixos /mnt
    swapon /dev/disk/by-label/swap
}

# Are you chure prompt
echo "You are going to loose all data on $DISK, do you want to format with $BOOT? [y/n]"
read answer
if [ -z $answer ]; then
    echo "Not answered yes 'y/Y'"
    exit
elif [[ $answer != [yY] ]]; then
    echo "Not answered yes 'y/Y'"
    exit
fi

# Install system
if [ $BOOT == "EFI" ]; then
    partitionEfi
elif [ $BOOT == "BIOS" ]; then
    partitionBios
else
    echo "Invalid boot, error?!"
    exit
fi

echo "Finished!"
