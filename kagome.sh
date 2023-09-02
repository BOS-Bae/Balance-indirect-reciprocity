#!/bin/bash

T=0.000
for ((i=0; i<100; i++))
do
    echo $T
    T=$(echo "$T + 0.010" | bc -l)  # Increment T by 0.01
    T=$(printf "%.5f" $T)  # Round T to 2 decimal places

    julia Kagome.jl $1 $2 10000000 1 0 0 $T >> /home/minwoo/Indirect-reciprocity-network-simulation/dat/Lx$1Ly$2_kagome.dat
done