#!/bin/bash

for ((i=0; i<16; i++))
do
	sbatch L6_run.sh $i
    sbatch L4_run.sh $i
done

for ((i=0; i<5; i++))
do
	sbatch L4_run_f.sh $i
done