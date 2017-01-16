#! /bin/sh

sudo pacman -Sy xorg-server xorg-xinit xorg-server-utils xautolock dmenu slock feh wget maim slop xclip

WP_DIR=${HOME}/.wallpapers
mkdir ${WP_DIR}

wget http://orig12.deviantart.net/2b71/f/2015/296/2/b/archlinux_wallpaper_by_tmleskovar-d9e3n5m.png -P ${WP_DIR}

cd ${DOTFILES}/wm/pkg

makepkg -csf
sudo pacman -U --noconfirm dwm-*pkg*

rm -fr dwm*
