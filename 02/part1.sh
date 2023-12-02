#!/bin/bash

color() {
	read line
	sed -e 's/, /\n/g' <<< "$line" | grep "$1" | sort -n | tail -1 | cut -d' ' -f1
}

possible() {
	read line
	red=$(color red <<< "$line")
	green=$(color green <<< "$line")
	blue=$(color blue <<< "$line")
	[ "$red" -gt 12 ] || [ "$green" -gt 13 ] || [ "$blue" -gt 14 ] && return 1
	return 0
}

sum=0

while read -a line; do
	id=$(tr -d ':' <<< "${line[1]}")
	tr ';' ',' <<< "${line[@]: 2}" | possible && ((sum+=id))
done

echo $sum
