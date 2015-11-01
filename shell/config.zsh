HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt complete_aliases

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "\e[3~" delete-char

export PATH=$DOTFILES/bin:$PATH
export SDL_VIDEO_X11_DGAMOUSE=0
