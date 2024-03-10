#!/bin/bash

for ((i=4; i<100; i++))
do
	./RandomWalk $i 3000 >> RW_L4.dat
done
