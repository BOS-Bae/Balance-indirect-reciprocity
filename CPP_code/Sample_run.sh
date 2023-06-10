#!/bin/bash

g++ fixation_time.cpp -o f_time -Ofast

N=$1
sl=$2
norm=$3

mkdir N$NL$sl

for ((i=0; i<10; i++))
do
    ./f_time {$N} {$sl} {$norm} > N$NL$sl/fixation_${i}
done