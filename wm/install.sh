#! /bin/sh

sudo pacman -Sy --noconfirm xorg-server xorg-xinit xorg-server-utils xautolock scrot imagemagick dmenu

WP_DIR=$HOME/.wallpapers
mkdir $WP_DIR

wget http://orig06.deviantart.net/a035/f/2011/308/9/2/arch_linux___kiss_by_abhinandh-d4exikc.png -P $WP_DIR
wget http://orig12.deviantart.net/2b71/f/2015/296/2/b/archlinux_wallpaper_by_tmleskovar-d9e3n5m.png -P $WP_DIR

cd $DOTFILES/wm/pkg

makepkg -csf
sudo pacman -U --noconfirm dwm-*pkg*
