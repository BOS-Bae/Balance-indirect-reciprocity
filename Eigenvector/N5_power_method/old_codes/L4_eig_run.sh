#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1      # Cores per node
#SBATCH --partition=g1,g2,g3,g4,g5        # Partition Name
##
#SBATCH --job-name=L4_eig
##SBATCH --time=24:00:00           # Runtime: HH:MM:SS
#SBATCH -o test.%N.%j.out         # STDOUT
#SBATCH -e test.%N.%j.err         # STDERR
##

hostname
date

cd $SLURM_SUBMIT_DIR

./L4_eig 0.0001 1000
