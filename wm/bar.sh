#! /bin/sh

__time() {
	echo -e "$(date +'%H:%M')" 
}

__date() {
	echo -e "$(date +'%a %d %b')" 
}

__cpu_format() {
	printf "%5.2f" "$(awk '{print ($1 - $2) * 100 / $1}'<<<"${1} ${2}")"
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
	printf "%5.1f %1sB/s" $(awk '{
		val = $1 / $2
		if (val < 512) {
			print val, " "
		} else {
			val = val / 1024
			if (val < 512) {
				print val, "K"
			} else {
				val = val / 1024
				if (val < 512) {
					print val, "M"
				} else {
					print val / 1024, "G"
				}
			}
		}
	}'<<<"${1} ${2}")
}

typeset -A __prev_net_rcv
typeset -A __prev_net_snd
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
			if [[ ! -z ${__net_str} ]]; then
				__net_str="${__net_str}  "
			fi
			__net_str="${__net_str}${name} $(__network_format ${sndd} ${1}) / $(__network_format ${rcvd} ${1})"
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
	xsetroot -name "$(echo -e "\033[38;5;8m\033[48;5;8m\033[38;5;15m \ue050 $(__volume) \033[30m\033[40m\033[38;5;15m \ue8d5 ${__net_str} \033[38;5;8m\033[48;5;8m\033[38;5;15m \ue322 ${__cpu_str} \033[30m\033[38;5;15m\033[40m \ue878 $(__date) \033[38;5;10m\033[48;5;10m\033[30m \ue8ae $(__time)")"
	sleep ${__interval}
done

