#!/bin/bash

T=0.600
for ((i=0; i<30; i++))
do
    echo $T
    T=$(echo "$T + 0.01" | bc -l)  # Increment T by 0.01
    T=$(printf "%.4f" $T)  # Round T to 2 decimal places

    julia Baxter_Wu.jl $1 1000000 1 $T >> L$1_BW_c.dat
done