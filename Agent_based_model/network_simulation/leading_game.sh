#!/bin/bash

N=50
samples=10
MCS=2000000
t_ms=1000000
assess_err=0.05
act_err=0.05

for ((r=1; r<=8; r++))
	do
		./game_L6 $N $r $samples $MCS $t_ms	$assess_err $act_err >> ./Leading_game_L6.dat
	done
