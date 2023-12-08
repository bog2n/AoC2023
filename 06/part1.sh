#!/bin/bash

read -a line
time=(${line[@]: 1})
read -a line
dist=(${line[@]: 1})

mkfifo ways
for i in ${!time[@]}; do
	sum=0
	for t in $(seq 1 ${time[$i]}); do
		[ $((t*time[i]-t**2)) -gt ${dist[$i]} ] && ((sum+=1))
	done
	echo $sum>ways&
done
echo $(($(tr '\n' '*'<ways;printf 1)))
rm ways
