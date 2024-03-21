#!/bin/bash

for ((i=100; i<200; i++))
do
	./RandomWalk $i 5000 >> RW_L4.dat
done
