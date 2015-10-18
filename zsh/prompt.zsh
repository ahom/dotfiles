autoload -U colors && colors

setopt prompt_subst
autoload -Uz vcs_info

zstyle ':vcs_info:git*' formats " (%{$fg[green]%}%b%{$fg[red]%}%u%{$fg[yellow]%}%c%{$reset_color%})"
zstyle ':vcs_info:*' check-for-changes true

precmd() { vcs_info }

PROMPT='%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~%{$reset_color%}${vcs_info_msg_0_} %'
RPROMPT='[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]'
