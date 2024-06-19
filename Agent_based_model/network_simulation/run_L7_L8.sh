#!/bin/bash

for ((i=0; i<100; i++))
do
	./sim_L7_L8 $1 $2 >> ./L7_L8_histo/L$1idx$2_hist.dat
done
