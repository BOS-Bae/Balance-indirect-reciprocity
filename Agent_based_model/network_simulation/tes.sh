#!/bin/bash

for ((N=4; N<$1; N++))
do
	mod=$((N % 2))
	if [ $mod -eq 0 ]
		then
			echo $N
		fi
done
