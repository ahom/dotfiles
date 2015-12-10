#! /bin/sh

sudo pacman -Sy --noconfirm neovim python2 xsel
sudo pip2 install neovim
sudo pip install neovim

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
