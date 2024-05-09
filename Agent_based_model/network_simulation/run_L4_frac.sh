#!/bin/bash

N=$1
for ((i=0; i<$N+1; i++))
do
	./small_frac_L4 $N 30 $i >> ./frac_L4_L6.dat
done
