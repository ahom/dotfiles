#! /bin/sh

__start_esc="\033["
__end_esc="m"

__fg() {
    echo -e "${__start_esc}38;5;${1}${__end_esc}"
}

__bg() {
    echo -e "${__start_esc}48;5;${1}${__end_esc}"
}

__fbg() {
    echo -e "${__start_esc}38;5;${1}${__end_esc}${__start_esc}48;5;${2}${__end_esc}"
}

__print() {
    local str=""
    if [[ ! -z ${3} ]]; then
        if [[ ! -z ${__currentbg} ]]; then
            if [[ ${__currentbg} != ${2} ]]; then
                str="${str}$(__fbg ${__currentbg} ${2}) "
            else
                str="${str}$(__fbg ${1} ${2}) "
            fi
        fi
        __status_str="$(__fbg ${1} ${2}) ${3} ${str}${__status_str}"
        __currentbg=${2}
    fi
}

__end() {
    __status_str="$(__fg ${__currentbg}) ${__status_str}"  
}

__grad() {
    expr 19 + ${1}
}

__fggrad() {
    __fg $(__grad ${1})
}

__bggrad() {
    __bg $(__grad ${1})
}

__time_str=""
__time() {
    __time_str="\ue8ae $(date +'%H:%M')" 
}

__date_str=""
__date() {
    __date_str="\ue878 $(date +'%a %d %b')" 
}

__cpu_format() {
    local val
    local grad
    read val grad <<<$(awk '{
        val = ($1 - $2) * 100 / $1
        grad = int((val / 100) * 10)
        print val, grad
    }'<<<"${1} ${2}")
    printf "$(__fggrad ${grad})%5.2f" "${val}"
}

__cpu_str=""
__prev_cpu_idle=""
__prev_cpu_total=""
__cpu() {
    local idle
    local total
    local idled
    local totald
    __cpu_str=""
    read idle total <<<"$(cat /proc/stat | grep cpu | head -1 | awk '{print $5+$6,$2+$3+$4+$5+$6+$7+$8+$9}')"
    if [[ ! -z ${__prev_idle} && ! -z ${__prev_total} ]]; then
        idled=`expr ${idle} - ${__prev_idle}`
        totald=`expr ${total} - ${__prev_total}`
        __cpu_str="\ue322 $(__cpu_format ${totald} ${idled})%"
    fi
    __prev_idle=${idle}
    __prev_total=${total}
}

__network_format() {
    local val
    local grad
    local suffix
    read val grad suffix <<<$(awk '{
        val = $1 / $3
        grad = int(( $1 / ($2 + 1)) * 10)
        suffix = ""
        if (val > 512) {
            val = val / 1024
            suffix = "K"
            if (val > 512) {
                val = val / 1024
                suffix = "M"
                if (val > 512) {
                    val = val / 1024
                    suffix = "G"
                }
            }
        }
        print val, grad, suffix
    }'<<<"${1} ${2} ${3}")
    printf "$(__fggrad ${grad})%5.1f %1sB/s" "${val}" "${suffix}"
}

__network_str=""
typeset -A __prev_net_rcv
typeset -A __prev_net_snd
typeset -A __max_net_rcvd
typeset -A __max_net_sndd
__network() {
    local name
    local rcv
    local snd
    local rcvd
    local sndd
    __net_str=""
    while read name rcv snd; do
        if [[ "$name" != "" ]]; then
            if [[ ! -z ${__prev_net_rcv[$name]} && ! -z ${__prev_net_snd[$name]} ]]; then
                rcvd=`expr ${rcv} - ${__prev_net_rcv[$name]}`
                sndd=`expr ${snd} - ${__prev_net_snd[$name]}`
                if [[ -z ${__max_net_rcvd[$name]} || ${rcvd} -gt ${__max_net_rcvd[$name]} ]]; then
                    __max_net_rcvd[$name]=${rcvd}
                fi
                if [[ -z ${__max_net_sndd[$name]} || ${sndd} -gt ${__max_net_sndd[$name]} ]]; then
                    __max_net_sndd[$name]=${sndd}
                fi
                if [[ ! -z ${__net_str} ]]; then
                    __net_str="${__net_str} $(__fg 15) "
                fi
                __net_str="${__net_str}\ue8d5 ${name} $(__network_format ${sndd} ${__max_net_sndd[$name]} ${1}) $(__fg 15)/ $(__network_format ${rcvd} ${__max_net_rcvd[$name]} ${1})"
            fi
            __prev_net_rcv[$name]=${rcv}
            __prev_net_snd[$name]=${snd}
        fi
    done <<<"$(cat /proc/net/dev | grep ':' | grep -e '^\s*en' -e '^\s*wl' | awk '{print $1,$2,$10}')"
}

__volume_str=""
__volume() {
    local volume
    local mute
    read volume mute <<<"$(amixer sget PCM | grep "%" | head -1 | awk -F"[][]" '{ print $2,$6 }')"
    if [[ "${mute}" = "off" ]]; then
        __volume_str="$(__fg 1)\ue04f$(__fg 15)"
    else
        __volume_str="\ue050"
    fi
    __volume_str="${__volume_str} ${volume}"
}

__battery_str=""
__battery() {
    if [[ "$(cat /sys/class/power_supply/BAT0/type)" = "Battery" ]]; then
        local val
        local grad
        read val grad <<<$(awk '{
            val = int(($1 / $2) * 100)
            grad = 10 - int(val / 10)
            print val, grad
        }'<<<"$(cat /sys/class/power_supply/BAT0/charge_now) $(cat /sys/class/power_supply/BAT0/charge_full_design)")
        if [[ "$(cat /sys/class/power_supply/BAT0/status)" = "Discharging" ]]; then
            __battery_str="\ue1a5"
        else
            __battery_str="$(__fg 2)\ue1a3" 
        fi
        __battery_str="${__battery_str} $(__fggrad ${grad})${val}% $(__bggrad ${grad})$(printf "%$(expr 10 - ${grad})s")$(__fg 0)$(__bg 0)$(printf "%${grad}s")$(__fg 8)$(__bg 8)" 
    fi
}

__interval=5
while true; do
    __cpu ${__interval}
    __network ${__interval}
    __volume ${__interval}
    __date ${__interval}
    __time ${__interval}
    __battery ${__interval}

    __currentbg=""
    __status_str=""
    __print 0 10 "${__time_str}"
    __print 15 0 "${__date_str}"
    __print 15 8 "${__battery_str}"
    __print 15 0 "${__volume_str}"
    __print 15 8 "${__cpu_str}"
    __print 15 0 "${__net_str}"
    __end

    xsetroot -name "$(echo -e "${__status_str}")"
    sleep ${__interval}
done

