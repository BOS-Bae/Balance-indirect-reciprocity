#!/bin/bash

N=$1
for ((i=0; i<$N+1; i++))
do
	./small_frac_L4 $N 200 $i >> ./frac_L4_N$N.dat
done
