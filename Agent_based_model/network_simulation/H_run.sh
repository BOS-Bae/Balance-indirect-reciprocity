#!/bin/bash

N=$1
r=6
mode=$2
ns=50

p=0.00
for ((i=0; i<50; i++))
do
		./homophily $N $p $r $ns $mode >> ./N$N-mode$mode
		p=$(echo "$p + 0.02" | bc -l)
done
