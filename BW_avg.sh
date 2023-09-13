#!/bin/bash
gcc avg_BW.c -lm -o avg_BW
T=0.7300
for ((i=0; i<250; i++))
do
	T=$(echo "$T + 0.0002" | bc -l)
	T=$(printf "%.6f" $T)
	./avg_BW $1 $T 5000000 $2 $3 >> L$1/L$1_BW.dat
done