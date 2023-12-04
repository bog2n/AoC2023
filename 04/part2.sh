#!/bin/bash

sum=0

declare -a cwon

while read -r line; do
	card=$(cut -d':' -f1 <<< "$line" | tr -d '[:alpha:]')
	win=($(cut -d':' -f2- <<< "$line" | cut -d'|' -f1))
	num=($(cut -d':' -f2- <<< "$line" | cut -d'|' -f2))
	amount=0
	for n in "${num[@]}"; do
		for w in "${win[@]}"; do
			[ "$n" -eq "$w" ] && ((amount+=1))
		done
	done
	((cwon[$card]+=1))
	for i in $(seq $((card+1)) $((card+amount))); do
		((cwon[$i]+=cwon[$card]))
	done
done

mkfifo sum
for i in "${cwon[@]}"; do
	echo $i > sum &
done
echo $(($(cat sum|tr '\n' '+';printf 0;)))
rm sum
