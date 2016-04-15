#! /usr/bin/fish

abbr -a gs git status -b -s
abbr -a gc git commit -m "
abbr -a gca git commit -a -m "
abbr -a gco git checkout
abbr -a vim nvim

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias chrome="google-chrome-stable"
alias vim="nvim"
alias vi="nvim"

set -x EDITOR nvim
set -x DOTFILES $HOME/.dotfiles
set -x _JAVA_AWT_WM_NONREPARENTING 1
