#!/bin/bash

extrapolate() {
	declare -a args
	for arg in "$@"; do
		((diff=arg-p))
		p=$arg
		args+=($diff)
	done
	sum=0
	p=${args[1]}
	for arg in "${args[@]: 1}"; do
		((diff=p-arg))
		((sum+=diff))
		p=$arg
	done
	echo $1
	if [[ $sum == 0 ]]; then
		echo ${args[@]: -1}
	else
		extrapolate ${args[@]: 1}
	fi
}

minus() {
	sign=+
	while read line; do
		if [ $sign == + ]; then
			sign=-
		else
			sign=+
		fi
		printf "%d%s" $line $sign
	done
}

sum=0
while read line; do
	((sum+=$(($(extrapolate ${line[@]}|minus;printf 0)))))
done
echo $sum
