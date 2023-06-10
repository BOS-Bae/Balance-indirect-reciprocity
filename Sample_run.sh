#!/bin/bash
N=$1
sl=$2
norm=$3
samples=$4

echo "Notice) You should set up the update rule with L$3_rule"
mkdir N${N}L${norm}

for ((i=1; i<$samples+1; i++))
do
    julia fixation_time.jl ${N} ${sl} > N${N}L${norm}/fixation_${i}
done