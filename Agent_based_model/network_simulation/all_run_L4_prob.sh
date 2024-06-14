#!/bin/bash

N=$1
q=0.00
for ((i=0; i<101; i++))
do
	./all_prob_frac_L4 $N 20 $q >> ./all_prob_L4_N$N.dat
	q=$(echo "$q + 0.01" | bc -l)
done
