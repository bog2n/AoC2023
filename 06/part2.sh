#!/bin/bash

read -a line
time=$(tr -d ' '<<<${line[@]: 1})
read -a line
dist=$(tr -d ' '<<<${line[@]: 1})

lower=0
upper=0

t=0
first=0
last=$time
while true; do
	t=$((first+(last-first)/2))
	if [ $((t*time-t**2)) -gt $dist ]; then
		last=$t
	else
		first=$t
	fi
	[ $((last-first)) -le 1 ] && lower=$last && break
done

t=0
first=0
last=$time
while true; do
	t=$((last-(last-first)/2))
	if [ $((t*time-t**2)) -gt $dist ]; then
		first=$t
	else
		last=$t
	fi
	[ $((last-first)) -le 1 ] && upper=$last && break
done

echo $((upper-lower))
