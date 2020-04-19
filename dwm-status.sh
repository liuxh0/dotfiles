#!/bin/sh

datetime() {
	date +"%a. %m-%d %H:%M"
}

cpu() {
	idle=$(top -bn 1 | grep Cpu | sed 's/.*,[[:space:]]\(.*\)[[:space:]]id.*/\1/')
	busy=$(echo "100-$idle" | bc | xargs printf '%4s')
	echo "C$busy%"
}

memory() {
	memtotal=$(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}')
	memavailable=$(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}')
	usage=$(echo "scale=1;100-100*$memavailable/$memtotal" | bc | xargs printf '%4s')
	echo "M$usage%"
}

power() {
	adp=$(cat /sys/class/power_supply/ADP1/online)
	bat_level=$(cat /sys/class/power_supply/BAT0/capacity)
	if [ $adp = "1" ]
	then
		pwrsrc='+'
	else
		pwrsrc='-'
	fi
	echo "$bat_level%$pwrsrc"
}

wifi() {
	iwgetid -r
}

while true
do
	xsetroot -name "$(cpu) $(memory) | $(wifi) $(power) | $(datetime)"
	sleep 2
done 
