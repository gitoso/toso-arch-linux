# === Import Env Variables ===
source /environment
rm /environment

# Time Zone
ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
hwclock --systohc

# Localization
sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8"         >> /etc/locale.conf
echo "KEYMAP=$KEYBOARD_LAYOUT"  >> /etc/vconsole.conf 

# /etc/hostname
echo "$u_HOSTNAME" >> /etc/hostname

# /etc/hosts
echo "127.0.0.1	localhost"                           >> /etc/hosts
echo "::1		localhost"                           >> /etc/hosts
echo "127.0.1.1	$u_HOSTNAME.localdomain	$u_HOSTNAME" >> /etc/hosts

# NetworkManager
pacman -S --noconfirm networkmanager nm-connection-editor network-manager-applet
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

# Initramfs
mkinitcpio -P

# Root Password
echo "----------------"
echo "Password for ROOT"
passwd

# Micro-code
if [ "$cpu_type" == "intel" ]
then
    pacman -S --noconfirm intel-ucode
elif [ "$cpu_type" == "amd" ]
then
    pacman -S --noconfirm amd-ucode
fi

# Boot Loader (GRUB)
if [ "$use_efi" == "true" ]
then
    pacman -S --noconfirm grub efibootmgr os-prober ntfs-3g
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg
else
    pacman -S --noconfirm grub os-prober ntfs-3g
    grub-install --target=i386-pc $grub_disk
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# User management
useradd -m -G adm,ftp,games,http,log,rfkill,sys,systemd-journal,uucp,wheel,lp $u_USERNAME
echo "----------------"
echo "Password for user $u_USERNAME"
passwd $u_USERNAME

# Enable multilib
sed -i '/#\[multilib\]/{N;s/\n#/\n/;P;D}' /etc/pacman.conf
sed -i "s/#\[multilib\]/\[multilib\]/g"   /etc/pacman.conf

# Driver install
if [ "$gpu_type" == "intel" ]
then
    pacman -Sy --noconfirm xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver
elif [ "$gpu_type" == "amd" ]
then
    pacman -Sy --noconfirm xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
elif [ "$gpu_type" == "nivida" ]
then
    pacman -Sy --noconfirm xf86-video-nouveau mesa lib32-mesa
fi

# Sudo install & config
pacman -S --noconfirm sudo
echo "$u_USERNAME ALL=(ALL) ALL" >> /etc/sudoers

# Utilities install
pacman -S --noconfirm vim git

# Install Basic GUI (XOrg + i3-gaps)
if [ "$install_gui" == "true" ]
then
    pacman -S --noconfirm xorg xorg-xinit i3 dmenu xdg-user-dirs
    cp .xinitrc /home/$u_USERNAME/.xinitrc
    chown $u_USERNAME /home/$u_USERNAME/.xinitrc
    chgrp $u_USERNAME /home/$u_USERNAME/.xinitrc
fi

# End installation
exit