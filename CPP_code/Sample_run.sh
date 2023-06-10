#!/bin/bash

g++ fixation_time.cpp -o f_time -Ofast

N=$1
sl=$2
norm=$3

mkdir N${N}L${norm}

for ((i=0; i<10; i++))
do
    ./f_time ${N} ${sl} ${norm} > N${N}L${norm}/fixation_${i}
done