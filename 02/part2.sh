#!/bin/bash

color() {
	read line
	sed -e 's/, /\n/g' <<< "$line" | grep "$1" | sort -n | tail -1 | cut -d' ' -f1
}

calculate() {
	read line
	red=$(color red <<< "$line")
	green=$(color green <<< "$line")
	blue=$(color blue <<< "$line")
	echo $((red*green*blue))
}

mkfifo sum

while read -a line; do
	id=$(tr -d ':' <<< "${line[1]}")
	tr ';' ',' <<< "${line[@]: 2}" | calculate > sum &
done

echo $(($(tr '\n' '+'<sum;printf 0)))
rm sum
