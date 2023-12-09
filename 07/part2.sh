#!/bin/bash

# A->E
# K->D
# Q->C
# J->1
# T->A

mkfifo sum types

get_type() {
	out=$(fold -w1 <<< "$1" | sort | uniq -c | sort -r)
	u=$(wc -l <<< $out)
	case "$u" in
		1) echo 7 ;;
		2)
			if [[ $(awk '{print $1}'<<<$out|head -1) == 4 ]]; then
				echo 6
			else
				echo 5
			fi
			;;
		3)
			if [[ $(awk '{print $1}'<<<$out|head -1) == 3 ]]; then
				echo 4
			else
				echo 3
			fi
			;;
		4) echo 2 ;;
		5) echo 1 ;;
	esac
}

while read -a line; do
	best=1
	if grep J <<< "${line[0]}" &>/dev/null; then
		for i in 2 3 4 5 6 7 8 9 T Q K A; do
			get_type $(tr 'J' $i<<<${line[0]}) > types &
		done
		best=$(sort -rn < types | head -1)
	else
		best=$(get_type ${line[0]})
	fi
	case "$best" in
		7) echo "${line[@]}" >> five;;
		6) echo "${line[@]}" >> four;;
		5) echo "${line[@]}" >> full;;
		4) echo "${line[@]}" >> three;;
		3) echo "${line[@]}" >> two;;
		2) echo "${line[@]}" >> one;;
		1) echo "${line[@]}" >> high;;
	esac
done

rank=1
for f in high one two three full four five; do
	touch $f
	for i in $(tr 'TJQKA' 'A1CDE'<$f |sort|cut -d' ' -f2); do
		echo $((i*rank))>sum&
		((rank+=1))
	done
done
echo $(($(tr '\n' '+'<sum;printf 0)))

rm high one two three full four five sum types
