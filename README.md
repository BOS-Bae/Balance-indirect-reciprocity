# The price of Stern Judging

This is a simulation code for numerical results of the paper : 'The price of Stern Judging'.

The description of each directory is below.

## network-simulation

There are codes for agent-based simulation of Stern Judging rule and L4 rule.
  
Available functions for the codes are in 'Indirect_network.jl'

## Ising

* kagome.jl : code for Monte Carlo simulation of Ising model with three-spin interaction on kagome lattice.
* Baxter_Wu.jl : code for checking if our result of Ising model on kagome lattice is correct.

We conducted the finite size scaling for the Baxter-Wu model, and checked that our code identifies the universality class of Baxter-Wu model well.
  
Available functions for the codes are in 'MonteCarlo.jl' in same directory.

## Eigenvector

* eig_nr.jl : code for diagonalization of transition matrix, where there is no self-loop.

* L6_eig.cpp : code (Stern Judigng rule) for conducting power-method instead of diagonalization.

* L4_eig.cpp :  code (L4 rule) for conducting power-method instead of diagonalization.

## LTD, Heat_bath_Heider

There are codes for reproducing the results of papers which are regarding our subjects.

