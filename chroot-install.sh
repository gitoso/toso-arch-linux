# === Parameters ===
KEYBOARD_LAYOUT=us
KEYBOARD_VARIANT=altgr-intl

# === Import Env Variables ===
source environment
rm environment

echo "--- Summary ---"
echo ""
echo "Hostname: $u_HOSTNAME"
echo "Username: $u_USERNAME"
echo "CPU Brand: $cpu_type"
echo "GPU Brand: $gpu_type"

# # Time Zone
# ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
# hwclock --systohc

# # Localization
# sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
# locale-gen
# echo "LANG=en_US.UTF-8"         >> /etc/locale.conf
# echo "KEYMAP=$KEYBOARD_LAYOUT"  >> /etc/vconsole.conf 

# # /etc/hostname
# echo "$u_HOSTNAME" >> /etc/hostname

# # /etc/hosts
# echo "127.0.0.1	localhost"                           >> /etc/hosts
# echo "::1		localhost"                           >> /etc/hosts
# echo "127.0.1.1	$u_HOSTNAME.localdomain	$u_HOSTNAME" >> /etc/hosts

# # NetworkManager
# pacman -S --noconfirm networkmanager nm-connection-editor network-manager-applet
# systemctl enable NetworkManager.service
# systemctl start NetworkManager.service

# # Initramfs
# mkinitcpio -P

# # Root Password
# echo "--- ROOT PASSWORD ---"
# passwd

# # Micro-code
# pacman -S --noconfirm amd-ucode intel-ucode

# # Boot Loader (GRUB)
# pacman -S --noconfirm grub efibootmgr os-prober ntfs-3g
# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
# grub-mkconfig -o /boot/grub/grub.cfg

# # User management
# useradd -m -G adm,ftp,games,http,log,rfkill,sys,systemd-journal,uucp,wheel,lp $u_USERNAME
# echo "--- Senha para o usuário $u_USERNAME ---"
# passwd $u_USERNAME

# # Enable multilib
# sed -i '/#\[multilib\]/{N;s/\n#/\n/;P;D}' /etc/pacman.conf
# sed -i "s/#\[multilib\]/\[multilib\]/g"   /etc/pacman.conf

# # Driver install
# #pacman -Sy --noconfirm xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
# pacman -Sy --noconfirm xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver

# # Sudo install & config
# pacman -S --noconfirm sudo
# echo "$u_USERNAME ALL=(ALL) ALL" >> /etc/sudoers

# # Utilities install
# pacman -S --noconfirm vim git

# # Call user config script
# chown $u_USERNAME user-install.sh
# cp user-install.sh /home/$u_USERNAME/user-install.sh
# su - $u_USERNAME -c "./user-install.sh"

# # End installation
# exit