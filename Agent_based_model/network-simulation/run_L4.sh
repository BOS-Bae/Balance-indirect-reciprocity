#!/bin/bash

N=$1
for ((i=1; i<$N; i++))
do
	./ABM_L4 $N $i 500 1000 >> cluster_N$N.dat
done
