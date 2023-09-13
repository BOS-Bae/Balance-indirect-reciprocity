#!/bin/bash

T=0.7300
for ((i=0; i<250; i++))
do
	T=$(echo "$T + 0.0002" | bc -l)
	T=$(printf "%.6f" $T)
	julia Baxter_Wu.jl $1 5000000 1 $T > ./dat_Baxter_Wu/L$1/L$1T$T.dat
done
