#! /bin/sh

cd ${DOTFILES}/term/pkg

makepkg -csf
sudo pacman -U --noconfirm st-*pkg*

rm -fr st*
