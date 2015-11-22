function lgrep -d "Grep with colors followed by less"
    grep --color=always $argv | less -R
end
