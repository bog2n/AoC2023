#!/bin/bash

mkfifo sum

while read -r line; do
	line=${line//oneight/oneeight}
	line=${line//threeight/threeeight}
	line=${line//fiveight/fiveeight}
	line=${line//nineight/nineeight}
	line=${line//twone/twoone}
	line=${line//sevenine/sevennine}
	line=${line//eightwo/eighttwo}
	line=${line//one/1}
	line=${line//two/2}
	line=${line//three/3}
	line=${line//four/4}
	line=${line//five/5}
	line=${line//six/6}
	line=${line//seven/7}
	line=${line//eight/8}
	line=${line//nine/9}
	numbers=$(tr -d '[:alpha:]' <<< "$line")
	echo "${numbers:0:1}${numbers: -1}" > sum &
done

echo $(($(tr '\n' '+'<sum;printf 0)))
rm sum
