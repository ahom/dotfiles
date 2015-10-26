#! /bin/sh

cd $DOTFILES/wm/pkg

makepkg -cs
sudo pacman -U dwm-*pkg*

rm -fr dwm*
