#!/bin/bash

declare -A maps
declare -a starts
declare -a steps

read nav
len=${#nav}

while read line; do
	test -z "$line" && continue
	index=$(cut -c1-3<<<$line)
	left=$(cut -c8-10<<<$line)
	right=$(cut -c13-15<<<$line)
	maps[${index},L]=$left
	maps[${index},R]=$right
	if [[ $index =~ ^..A ]]; then
		starts+=($index)
	fi
done

for s in ${!starts[@]}; do
	here=${starts[$s]}
	step=0

	while true; do
		i=${nav:$((step%len)):1}
		here=${maps[$here,$i]}
		((step+=1))
		[[ $here =~ ^..Z ]] && break
	done

	steps[$s]=$step
done

mkfifo out
for i in ${steps[@]}; do
	factor $i|cut -d' ' -f2-|tr ' ' '\n'>out&
done
echo $(($(sort < out|uniq|tr '\n' '*';printf 1)))
rm out
