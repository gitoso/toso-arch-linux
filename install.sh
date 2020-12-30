#!/bin/bash

# === Disclaimers ===
echo 'Attention: Check if you are connected to the insternet before using this script'
echo 'Attention: Partition disks before using this script'
echo 'Press [ENTER] to continue'
read _
cd /

# === Parameters ===
KEYBOARD_LAYOUT=us
KEYBOARD_VARIANT=altgr-intl

# === Instalation ===
loadkeys $KEYBOARD_LAYOUT
timedatectl set-ntp true

# === Ask User Questions ===
read -p "Hostname: " u_HOSTNAME
while true
do
    read -p "Root Password: " u_ROOTPASS
    read -p "Root Password Confirmation: " u_ROOTPASSCONFIRM
    if [ "$u_ROOTPASS" != "" ]
    then
        if [ "$u_ROOTPASS" == "$u_ROOTPASSCONFIRM" ]
        then
            break
        fi
    fi
    echo "Invalid Confirmation"
done
read -p "Username: " u_USERNAME
while true
do
    read -p "User Password: " u_USERPASS
read -p "User Password Confirmation: " u_USERPASSCONFIRM
    if [ "$u_USERPASS" != "" ]
    then
        if [ "$u_USERPASS" == "$u_USERPASSCONFIRM" ]
        then
            break
        fi
    fi
    echo "Invalid Confirmation"
done

# Machine Info
while true
do
    echo "----------------"
    echo "CPU Brand?"
    echo "   1. Intel"
    echo "   2. AMD"
    read -p "Option: " cpu_type_input
    if [ "$cpu_type_input" == "1" ]
    then
        cpu_type="intel"
        break
    elif [ "$cpu_type_input" == "2" ]
    then
        cpu_type="amd"
        break
    fi
    clear
done

while true
do
    echo "----------------"
    echo "GPU Brand?"
    echo "   1. Intel"
    echo "   2. Nvidia"
    echo "   3. AMD"
    read -p "Option: " gpu_type_input
    if [ "$gpu_type_input" == "1" ]
    then
        gpu_type="intel"
        break
    elif [ "$gpu_type_input" == "2" ]
    then
        gpu_type="nvidia"
        break
    elif [ "$gpu_type_input" == "3" ]
    then
        gpu_type="amd"
        break
    fi
    clear
done

# === Partitioning ===
clear
echo 'These are your disks'
fdisk -l
echo ""
# Root partition /
read -p "Select partition to install base system: " root_partition

# EFI partition
while true
do
    read -p "Are you installing this system in UEFI mode? [Y/n] " use_efi_input
    if [ "$use_efi_input" == "y" ] || [ "$use_efi_input" == "Y" ] || [ "$use_efi_input" == "" ]
    then
        use_efi="true"
        read -p "EFI partition: " efi_partition
        break
    elif [ "$use_efi_input" == "n" ] || [ "$use_efi_input" == "N" ]
    then
        use_efi="false"
        break
    fi
    clear
done

if [ $use_efi == "true" ] ;
then
    while true
    do
        read -p 'Should EFI partition be formatted? [y/N] ' format_efi_input
        if [ "$format_efi_input" == "y" ] || [ "$format_efi_input" == "Y" ] || [ "$format_efi_input" == "" ]
        then
            format_efi="true"
            break
        elif [ "$format_efi_input" == "n" ] || [ "$format_efi_input" == "N" ]
        then
            format_efi="false"
            break
        fi
        clear
    done
fi

# Swap partition
while true
do
    read -p 'Should swap be used? [y/N] ' use_swap_input
    if [ "$use_swap_input" == "y" ] || [ "$use_swap_input" == "Y" ]
    then
        use_swap="true"
        read -p "Swap partition: " swap_partition
        break
    elif [ "$use_swap_input" == "n" ] || [ "$use_swap_input" == "N" ] || [ "$use_swap_input" == "" ]
    then
        use_swap="false"
        break
    fi
    clear
done


# === Formating ===
while true
do
    echo "Which Filesystem should be used to / partition?"
    echo "   1. ext4"
    echo "   2. btrfs"
    read -p "Filesystem: " fs_type_input
    if [ "$fs_type_input" == "1" ]
    then
        fs_type="ext4"
        break
    elif [ "$fs_type_input" == "2" ]
    then
        fs_type="btrfs"
        break
    fi
    clear
done

# === Confirm before continue ===
clear
echo "--- Summary ---"
echo ""
echo "Hostname: $u_HOSTNAME"
echo "Username: $u_USERNAME"
echo "CPU Brand: $cpu_type"
echo "GPU Brand: $gpu_type"
echo ""
echo "Use EFI: $use_efi"
if [ $use_efi == "true" ]
then
    echo "EFI Partition: $efi_partition"
fi
echo ""
echo "Use SWAP: $use_swap"
if [ $use_swap == "true" ]
then
    echo "Swap Partition: $swap_partition"
fi
echo ""
echo "Root Partition: $root_partition"
echo "Root FS: $fs_type"
echo ""
echo "Press [ENTER] to continue (or Ctrl+C to abort)"
read _

# === Format ===
if [ $fs_type == "ext4" ] 
then
    mkfs.ext4 $root_partition
elif [ $fs_type == "btrfs" ] 
then
    mkfs.btrfs -f -L ArchLinux $root_partition
fi

if [ $use_swap == "y" ] 
then
    mkswap $swap_partition
fi
if [ $format_efi == "true" ] 
then
    mkfs.fat -F32 $efi_partition
fi

# === Mounting partitions ===
# /
mount $root_partition /mnt
# /efi
if [ $use_efi == "true" ]
then
    mkdir /mnt/efi
    mount $efi_partition /mnt/efi
fi
# swap
if [ $use_swap == "true" ] 
then
    swapon $swap_partition
fi

# === Adjusting mirrorlist to Brazilian mirrors ===
cat /etc/pacman.d/mirrorlist | grep -A1 Brazil | grep -v Brazil > br_mirrors
cat /etc/pacman.d/mirrorlist >> br_mirrors
mv br_mirrors /etc/pacman.d/mirrorlist

# === Installation ===
pacstrap /mnt base base-devel linux linux-firmware

# === System config ===

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# ENV
echo "u_HOSTNAME=$u_HOSTNAME" > /mnt/environment
echo "u_USERNAME=$u_USERNAME" >> /mnt/environment
echo "u_USERPASS=$u_USERPASS" >> /mnt/environment
echo "u_ROOTPASS=$u_ROOTPASS" >> /mnt/environment
echo "cpu_type=$cpu_type" >> /mnt/environment
echo "gpu_type=$gpu_type" >> /mnt/environment

# chroot
cp /root/toso-arch-linux/chroot-install.sh /mnt/chroot-install.sh
cp /root/toso-arch-linux/user-install.sh /mnt/user-install.sh
arch-chroot /mnt ./chroot-install.sh

# reboot
#reboot