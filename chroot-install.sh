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

# Initramfs
mkinitcpio -P

# Root Password
echo "--- ROOT PASSWORD ---"
passwd

# Boot Loader