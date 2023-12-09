#!/bin/bash

declare -A maps

read nav

while read line; do
	test -z "$line" && continue
	index=$(cut -c1-3<<<$line)
	left=$(cut -c8-10<<<$line)
	right=$(cut -c13-15<<<$line)
	maps[${index},L]=$left
	maps[${index},R]=$right
done

steps=0
here=AAA
len=${#nav}

while true; do
	i=${nav:$((steps%len)):1}
	here=${maps[$here,$i]}
	((steps+=1))
	[[ $here == ZZZ ]] && break
done

echo $steps
