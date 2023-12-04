#!/bin/bash

sum=0

while read -r line; do
	win=($(cut -d':' -f2- <<< "$line" | cut -d'|' -f1))
	num=($(cut -d':' -f2- <<< "$line" | cut -d'|' -f2))
	amount=-1
	for n in "${num[@]}"; do
		for w in "${win[@]}"; do
			[ "$n" -eq "$w" ] && ((amount+=1))
		done
	done
	if [[ $amount -ge 0 ]]; then
		((sum+=2 ** amount))
	fi
done

echo $sum
