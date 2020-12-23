# Dotfiles
su $u_USERNAME
git clone https://github.com/gitoso/dotfiles Dotfiles
cd Dotfiles

# .xinitrc
cp .xinitrc ~/.xinitrc

# i3 config
mkdir ~/.config/i3
cp .config/i3/config ~/.config/i3/config

# End Config
exit