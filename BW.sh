#!/bin/bash

T=1.0000
for ((i=0; i<450; i++))
do
	if [ "$(echo "$T > 2.0000" | bc -l)" -eq 1 ] && [ "$(echo "$T < 2.5000" | bc -l)" -eq 1 ]
	then
		T=$(echo "$T + 0.002" | bc -l)
		T=$(printf "%.5f" $T)
	else
		T=$(echo "$T + 0.02" | bc -l)
		T=$(printf "%.5f" $T)
	fi
	julia Baxter_Wu.jl $1 5000000 1 $T > ./dat_Baxter_Wu/L$1/L$1T$T.dat
done