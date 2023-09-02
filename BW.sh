#!/bin/bash

T=0.740
for ((i=0; i<35; i++))
do
    echo $T
    T=$(echo "$T + 0.001" | bc -l)  # Increment T by 0.01
    T=$(printf "%.5f" $T)  # Round T to 2 decimal places

    julia Baxter_Wu.jl $1 1000000 1 $T >> /home/minwoo/Indirect-reciprocity-network-simulation/dat/L$1_BW_c.dat
done