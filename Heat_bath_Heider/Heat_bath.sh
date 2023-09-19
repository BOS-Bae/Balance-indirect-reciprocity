#!/bin/bash

for ((i=0; i<30; i++))
do
    echo $i
    julia Heat_bath_Heider.jl $1 $i 10000 >> N$1_R.dat
done