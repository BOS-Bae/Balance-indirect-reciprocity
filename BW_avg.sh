#!/bin/bash
gcc avg_BW.c -lm -o avg_BW
T=1.0000
for ((i=0; i<337; i++))
do
	if [ "$(echo "$T > 2.0000" | bc -l)" -eq 1 ] && [ "$(echo "$T < 2.5000" | bc -l)" -eq 1 ]
	then
		T=$(echo "$T + 0.002" | bc -l)
		T=$(printf "%.5f" $T)
	else
		T=$(echo "$T + 0.02" | bc -l)
		T=$(printf "%.5f" $T)
	fi
	./avg_BW $1 $T 5000000 $2 $3 >> L$1/L$1_BW.dat
done
