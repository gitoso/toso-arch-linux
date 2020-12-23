#!/bin/bash

# === Disclaimers ===
echo 'Attention: Check if you are connected to the insternet before using this script [ENTER]'
read _
echo 'Attention: Partition disks before using this script [ENTER]'
read _
cd /

# === Parameters ===
KEYBOARD_LAYOUT=us
KEYBOARD_VARIANT=altgr-intl

# === Instalation ===
loadkeys $KEYBOARD_LAYOUT
timedatectl set-ntp true

# === Partitioning ===
echo 'These are your disks'
fdisk -l
echo ""
# Root partition /
read -p "Select partition to install base system: " root_partition
# EFI partition
read -p "EFI partition: " efi_partition
read -p 'Should EFI partition be formatted? [y/N] ' format_efi
# Swap partition
read -p 'Should swap be used? [y/N] ' use_swap
if [ $use_swap == "y" ] 
then
    read -p 'Swap partition: ' swap_partition
fi


# === Formating ===
mkfs.btrfs -f -L ArchLinux $root_partition
if [ $use_swap == "y" ] 
then
    mkswap $swap_partition
fi
if [ $format_efi == "y" ] 
then
    mkfs.fat -F32 $efi_partition
fi

# === Mounting partitions ===
mount $root_partition /mnt
mkdir /mnt/efi
mount $efi_partition /mnt/efi
if [ $use_swap == "y" ] 
then
    swapon $swap_partition
fi

# === Adjusting mirrorlist to Brazilian mirrors ===
cat /etc/pacman.d/mirrorlist | grep -A1 Brazil | grep -v Brazil > br_mirrors
cat /etc/pacman.d/mirrorlist >> br_mirrors
mv br_mirrors /etc/pacman.d/mirrorlist

# === Installation ===
pacstrap /mnt base linux linux-firmware

# === System config ===

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
cp /root/toso-arch-linux/chroot-install.sh /mnt/chroot-install.sh
cp /root/toso-arch-linux/user-install.sh /mnt/user-install.sh
arch-chroot /mnt ./chroot-install.sh

# reboot
reboot