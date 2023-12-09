#!/bin/bash

# A->E
# K->D
# Q->C
# J->1
# T->A

mkfifo sum

while read -a line; do
	out=$(fold -w1 <<< ${line[0]} | sort | uniq -c | sort -r)
	u=$(wc -l <<< $out)
	case "$u" in
		1) echo ${line[@]}>>five ;;
		2)
			if [[ $(awk '{print $1}'<<<$out|head -1) == 4 ]]; then
				echo ${line[@]}>>four
			else
				echo ${line[@]}>>full
			fi
			;;
		3)
			if [[ $(awk '{print $1}'<<<$out|head -1) == 3 ]]; then
				echo ${line[@]}>>three
			else
				echo ${line[@]}>>two
			fi
			;;
		4) echo ${line[@]}>>one ;;
		5) echo ${line[@]}>>high ;;
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

rm high one two three full four five sum
