#! /bin/sh

sudo pacman -Sy --noconfirm vim xsel

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
