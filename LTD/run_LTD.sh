#!/bin/bash

p=0.000
for ((i=0; i<50; i++))
do
    if [ "$(echo "$p > 0.400" | bc -l)" -eq 1 ]
	then
		p=$(echo "$p + 0.005" | bc -l)
		p=$(printf "%.3f" $p)
	else
		p=$(echo "$p + 0.020" | bc -l)
		p=$(printf "%.3f" $p)
	fi
	julia LTD.jl $1 $p 10000 20 >> dat_LTD_N$1
done
