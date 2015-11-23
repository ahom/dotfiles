#! /usr/bin/fish

abbr -a vim nvim

abbr -a gs git status -b -s
abbr -a gc git commit
abbr -a gca git commit -a
abbr -a gco git checkout

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias chrome="google-chrome-stable"

set -x DOTFILES $HOME/.dotfiles
