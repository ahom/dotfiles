#! /bin/sh

__time() {
	echo -e "$(date +'%H:%M')" 
}

__date() {
	echo -e "$(date +'%a %d %b')" 
}

__cpu_format() {
	awk '{
		val = ($1 - $2) * 100 / $1
		col = 19 + int((val / 100) * 10)
		printf("\033[38;5;%dm%5.2f", col, val)
	}'<<<"${1} ${2}"
}

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
		__cpu_str="$(__cpu_format ${totald} ${idled})"
	fi
	__prev_idle=${idle}
	__prev_total=${total}
}

__network_format() {
	awk '{
		val = $1 / $3
		col = 19 + int(( $1 / ($2 + 1)) * 10)
		suffix = " "
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
		printf("\033[38;5;%dm%5.1f %1sB/s", col, val, suffix)
	}'<<<"${1} ${2} ${3}"
}

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
				__net_str="${__net_str} \033[38;5;15m "
			fi
			__net_str="${__net_str}\ue8d5 ${name} $(__network_format ${sndd} ${__max_net_sndd[$name]} ${1}) \033[38;5;15m/ $(__network_format ${rcvd} ${__max_net_rcvd[$name]} ${1})"
		fi
		__prev_net_rcv[$name]=${rcv}
		__prev_net_snd[$name]=${snd}
	done <<<"$(cat /proc/net/dev | grep ':' | grep -v 'lo' | awk '{print $1,$2,$10}')"
}

__volume() {
	echo "$(amixer sget Master | grep "%" | head -1 | awk -F"[][]" '{ print $2 }')"
}

__interval=1
while true; do
	__cpu ${__interval}
	__network ${__interval}
	xsetroot -name "$(echo -e "\033[38;5;8m\033[48;5;8m\033[38;5;15m \ue050 $(__volume) \033[30m\033[40m\033[38;5;15m ${__net_str} \033[38;5;8m\033[48;5;8m\033[38;5;15m \ue322 ${__cpu_str}% \033[30m\033[38;5;15m\033[40m \ue878 $(__date) \033[38;5;10m\033[48;5;10m\033[30m \ue8ae $(__time)")"
	sleep ${__interval}
done

