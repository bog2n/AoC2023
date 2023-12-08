#!/bin/bash

declare -a seeds
declare -a modified
state=0

while read -a line; do
	case "$state" in
		0)
			seeds=(${line[@]: 1})
			state=1
		;;
		1)
			test -z "$line" && continue
			modified=()
			state=2
		;;
		2)
			test -z "$line" && state=1 && continue
			for i in "${!seeds[@]}"; do
				seed=${seeds[$i]}
				dst=${line[0]}
				src=${line[1]}
				rng=${line[2]}
				if [ $seed -ge $src ] && [ $seed -lt $((src+rng)) ]; then
					ok=1
					for k in "${modified[@]}"; do
						if [[ $k == $i ]]; then
							ok=0
							break
						fi
					done
					if [[ $ok == 1 ]]; then
						seeds[$i]=$((seed-src+dst))
						modified+=($i)
					fi
				fi
			done
		;;
	esac
done

lowest=${seeds[0]}
for seed in "${seeds[@]}"; do
	[ $seed -lt $lowest ] && lowest=$seed
done
echo $lowest
