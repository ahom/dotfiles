#! /bin/sh


__time() {
	echo -e "$(date +'%H:%M')" 
}

__date() {
	echo -e "$(date +'%a %d %b')" 
}

__cpu() {
	echo -e "cpu" 
}

__network() {
	echo -e "net" 
}

__mails() {
	echo -e "mails"
}

xsetroot -name "$(echo -e "\x09\x08 \ue89b $(__mails) \x02 \ue8d5 $(__network) \x07\x05 \ue322 $(__cpu) \x06\x02 \ue878 $(__date) \x04\x03 \ue8ae $(__time)")"
 
