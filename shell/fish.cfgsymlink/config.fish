#! /usr/bin/fish

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias chrome="google-chrome-stable"
alias vim="nvim"
alias vi="nvim"
alias gs="git status -b -s"
alias gca="git commit -a"

set -x EDITOR nvim
set -x DOTFILES $HOME/.dotfiles
set -x _JAVA_AWT_WM_NONREPARENTING 1
