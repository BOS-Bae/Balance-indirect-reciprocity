#!/bin/bash

e=0.0001

./tes2.sh  $e 1000 4 0 0 0
./tes2.sh  $e 1000 6 0 0 0

for ((i=0; i<32; i++))
do
	  ./tes2.sh $e 10 4 1 $i 0
done

for ((i=0; i<32; i++))
do
	  ./tes2.sh $e 10 6 1 $i 0
done

for ((i=0; i<7; i++))
do
	  ./tes2.sh $e 10 4 2 0 $i
done

for ((i=0; i<7; i++))
do
	  ./tes2.sh $e 10 6 2 0 $i
done
