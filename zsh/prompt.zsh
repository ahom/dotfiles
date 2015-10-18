autoload -U colors && colors

setopt prompt_subst
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision false
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:git*:*' stagedstr "%{$fg[green]%}↑ "
zstyle ':vcs_info:git*:*' unstagedstr "%{$fg[red]%}⚡ "
zstyle ':vcs_info:git*' formats "{%{$fg[green]%}%s %u%c%{$fg[blue]%}%r %{$fg[yellow]%}%b%m%{$reset_color%}} "

precmd() { vcs_info }

PROMPT='
%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$reset_color%}${vcs_info_msg_0_}[%{$fg_no_bold[yellow]%}%~%{$reset_color%}]
# '
RPROMPT='%T [%{$fg_no_bold[yellow]%}%?%{$reset_color%}]'
