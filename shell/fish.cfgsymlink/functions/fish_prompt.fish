set color00 282a2e  # Black
set color01 a54242  # Red
set color02 8c9440  # Green
set color03 de935f  # Yellow
set color04 5f819d  # Blue
set color05 85678f  # Magenta
set color06 5e8d87  # Cyan
set color07 707880  # White
set color08 373b41  # Bright Black
set color09 cc6666  # Bright Red
set color10 b5bd68  # Bright Green
set color11 f0c674  # Bright Yellow
set color12 81a2be  # Bright Blue
set color13 b294bb  # Bright Magenta
set color14 8abeb7  # Bright Cyan
set color15 c5c8c6  # Bright White
set color_foreground c5c8c6  # Foreground
set color_background 1d1f21  # Background
set color_cursor c3ff00      # Cursor color 

set current_fg_color $color_foreground
set current_bg_color $color_background

set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_char_dirtystate "✚ "
set __fish_git_prompt_char_invalidstate "✖ "
set __fish_git_prompt_char_stagedstate "● "
set __fish_git_prompt_char_cleanstate "✔ "

function prompt_hostname
    printf "%s" (hostname)
end

function prompt_username
    printf "%s" (id -u -n)
end

function prompt_cwd
    printf "%s" (prompt_pwd)
end

set prompt_first_string 1
function __add_prompt_segment
    if [ (count $argv) = 3 ]
        if [ $prompt_first_string != 1 ]
            set_color $current_bg_color
            set_color -b $argv[2]
            printf "%s" ""
        end
        set prompt_first_string 0
        set current_fg_color $argv[1]
        set current_bg_color $argv[2]
        set_color $current_fg_color
        set_color -b $current_bg_color
        printf " %s " $argv[3]
    end
end

function prompt_exit_status
    if [ $argv[1] -gt 0 ]
        printf "%s" $argv[1]
    end
end

function fish_prompt -d "Write out the prompt"
    set last_exit_status $status
    set prompt_first_string 1
    __add_prompt_segment $color_foreground $color05 (prompt_hostname)
    __add_prompt_segment $color_foreground $color00 (prompt_username)
    __add_prompt_segment $color_foreground $color08 (prompt_cwd)
    __add_prompt_segment $color_foreground $color01 (prompt_exit_status $last_exit_status)
    __add_prompt_segment $color_foreground $color_background " "
    printf "%s" "
"
    set_color -o $color04
    printf "%s" "\$ "
    set_color normal
end

function fish_right_prompt -d "Write out the right prompt"
    set -l __gp (__fish_git_prompt " %s")
    if test -n "$__gp"
        printf "%s  " "$__gp"
    end
    date "+%X"
end
