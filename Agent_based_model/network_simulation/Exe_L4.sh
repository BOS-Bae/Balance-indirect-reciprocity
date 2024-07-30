#!/bin/bash

for ((N=4; N<$1; N++))
do
	./Exe_L4_ABM_histogram $N 4 1000000 >> Execution_L4.dat
done
