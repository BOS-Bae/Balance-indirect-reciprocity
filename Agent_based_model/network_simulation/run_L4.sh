#!/bin/bash

N=$1
for ((i=0; i<$N+1; i++))
do
	./ABM_L4 $N $i $2 1000 >> ./cluster_dat_L4/cluster_N$N.dat
done
