# === Parameters ===
KEYBOARD_LAYOUT=us
KEYBOARD_VARIANT=altgr-intl
u_HOSTNAME=TESTE
u_USERNAME=gitoso

# === User Config ===
#read -p "System Hostname: " u_HOSTNAME
#read -p "Username: " u_USERNAME

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
echo "--- ROOT PASSWORD ---"
passwd

# Micro-code
pacman -S --noconfirm amd-ucode intel-ucode

# Boot Loader (GRUB)
pacman -S --noconfirm grub efibootmgr os-prober ntfs-3g
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# User management
useradd -m -G adm,ftp,games,http,log,rfkill,sys,systemd-journal,uucp,wheel,lp $u_USERNAME
echo "--- Senha para o usuário $u_USERNAME ---"
passwd $u_USERNAME

# Enable multilib
sed -i '/#\[multilib\]/{N;s/\n#/\n/;P;D}' /etc/pacman.conf
sed -i "s/#\[multilib\]/\[multilib\]/g"   /etc/pacman.conf

# Driver install
#pacman -Sy --noconfirm xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
pacman -Sy --noconfirm xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver

# GUI and User Utilities
pacman -S --noconfirm xorg xorg-xinit i3 dmenu xdg-user-dirs

# Utilities (for Dotfiles)
pacman -S --noconfirm vim git

# Call user config script
cp user-install.sh /home/$u_USERNAME/user-install.sh
su - $u_USERNAME -c "./user-install.sh"

# End installation
exit