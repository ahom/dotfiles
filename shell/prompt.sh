setopt prompt_subst

__start_esc="\033["
__end_esc="m"

__bold() {
    echo -e "%{${__start_esc}1${__end_esc}%}${1}"
}

__fg() {
    local text=${3}
    if [[ ${1} -eq 1 ]]; then
        text="$(__bold ${text})"
    fi
    echo -e "%{${__start_esc}38;5;${2}${__end_esc}%}${text}%{${__start_esc}0${__end_esc}%}"
}

__bg() {
    local text=${3}
    if [[ ${1} -eq 1 ]]; then
        text="$(__bold ${text})"
    fi
    echo -e "%{${__start_esc}48;5;${2}${__end_esc}%}${text}%{${__start_esc}49${__end_esc}%}"
}

__fbg() {
    local text=${4}
    if [[ ${1} -eq 1 ]]; then
        text="$(__bold ${text})"
    fi
    echo -e "%{${__start_esc}38;5;${2}${__end_esc}${__start_esc}48;5;${3}${__end_esc}%}${text}%{${__start_esc}49${__end_esc}${__start_esc}0${__end_esc}%}"
}

__print() {
    local str=""
    if [[ ! -z ${4} ]]; then
        if [[ ! -z ${__currentbg} ]]; then
            if [[ ${__currentbg} != ${3} ]]; then
                str="${str}$(__fbg 0 ${__currentbg} ${3} )"
            else
                str="${str}$(__fbg 0 ${2} ${3} )"
            fi
        fi
        __prompt_str="${__prompt_str}${str}$(__fbg ${1} ${2} ${3} " ${4} ")"
        __currentbg=${3}
    fi
}

__end() {
    __prompt_str="${__prompt_str}$(__fg 0 ${__currentbg} )"    
}

__hostname() {
    printf "%s" "$(hostname)"
}

__username() {
    printf "%s" "$(id -u -n)"
}

__cwd() {
    local dir_limit="3"
    local truncation="⋯"
    local first_char
    local part_count=0
    local formatted_cwd=""
    local dir_sep="  "
    local tilde="~"

    local cwd="${PWD/#$HOME/$tilde}"

      first_char=${cwd[1,1]}

    # remove leading tilde
      cwd="${cwd#\~}"

    while [[ "${cwd}" == */* && "${cwd}" != "/" ]]; do
        [[ ${part_count} -eq ${dir_limit} ]] && first_char="${truncation}" && break
            
        # pop off last part of cwd
        local part="${cwd##*/}"
        if [[ ${part_count} -eq 0 ]]; then
            part="$(__bold ${part})"
        fi

            cwd="${cwd%/*}"

            part_count=$((part_count+1))
        formatted_cwd="${dir_sep}${part}${formatted_cwd}"
      done
    
    if [[ ${part_count} -eq 0 ]]; then
        first_char="$(__bold ${first_char})"
    fi
    printf "%s" "${first_char}${formatted_cwd}"
}

__git_branch() {
      local branch
      local branch_symbol=" "

      # git
      if hash git 2>/dev/null; then
            if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
                  branch=${branch##*/}
                  printf "%s" "${branch_symbol}${branch:-unknown}"
                  return
            fi
      fi
    return 1
}

__git() {
    [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

    local added_symbol="·"
    local unmerged_symbol="✗"
    local modified_symbol="+"
    local clean_symbol="="
    local has_untracked_files_symbol="…"

    local ahead_symbol="↑"
    local behind_symbol="↓"

    local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean=""

    set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    local behind_count=$1
    local ahead_count=$2

    # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), changed (T), Unmerged (U), Unknown (X), Broken (B)
    while read line; do
            case "$line" in
                  M*) modified_count=$(( $modified_count + 1 )) ;;
                  U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
            esac
      done < <(git diff --name-status)

      while read line; do
            case "$line" in
                  *) added_count=$(( $added_count + 1 )) ;;
            esac
      done < <(git diff --name-status --cached)

    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
            has_untracked_files=1
      fi

      if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
            is_clean=1
      fi

      local leading_whitespace=""
      [[ $ahead_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$ahead_symbol$ahead_count"; leading_whitespace=" "; }
      [[ $behind_count -gt 0 ]]        && { printf "%s" "$leading_whitespace$behind_symbol$behind_count"; leading_whitespace=" "; }
      [[ $modified_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$modified_symbol$modified_count"; leading_whitespace=" "; }
      [[ $unmerged_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$unmerged_symbol$unmerged_count"; leading_whitespace=" "; }
      [[ $added_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$added_symbol$added_count"; leading_whitespace=" "; }
      [[ $has_untracked_files -gt 0 ]] && { printf "%s" "$leading_whitespace$has_untracked_files_symbol"; leading_whitespace=" "; }
      [[ $is_clean -gt 0 ]]            && { printf "%s" "$leading_whitespace$clean_symbol"; leading_whitespace=" "; }
}

__last_exit_code() {
      [[ ${1} -gt 0 ]] || return 1;
      printf "%s" "${1}"
}

__prompt() {
    local exit_code=$?
    __prompt_str=""
    __print 0 255 5 "$(__hostname)"
    __print 1 255 0 "$(__username)"
    __print 0 15 8 "$(__cwd)"
    __print 0 255 0 "$(__git_branch)"
    __print 0 0 10 "$(__git)"
    __print 0 255 1 "$(__last_exit_code $exit_code)"
    __end
    printf "%s" "${__prompt_str}
$(__fg 1 4 \$) "
}

PROMPT='$(__prompt)'

