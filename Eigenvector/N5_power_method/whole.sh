#!/bin/bash

for ((i=0; i<32; i++))
do
	sbatch L6_run.sh $i
    sbatch L4_run.sh $i
done

for ((i=0; i<7; i++))
do
	sbatch L6_run_f.sh $i
	sbatch L4_run_f.sh $i
done

sbatch L6_eig_run.sh
sbatch L4_eig_run.sh