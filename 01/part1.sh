#!/bin/bash

mkfifo sum

while read -r line; do
	numbers=$(tr -d '[:alpha:]' <<< "$line")
	echo "${numbers:0:1}${numbers: -1}" > sum &
done

echo $(($(tr '\n' '+'<sum;printf 0)))

rm sum
