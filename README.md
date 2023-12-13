# The price of Stern Judging

This are simulation codes which generate numerical results of the paper : 'The price of Stern Judging'.

The description of each directory is below.

## network-simulation

There are codes for agent-based simulation of Stern Judging rule and L4 rule.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/L6_fixation.png" width="400" height="250"/>

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/L4_fixation.png" width="400" height="250"/>

Available functions for the codes are in 'Indirect_network.jl'

## Ising

* kagome.jl : code for Monte Carlo simulation of Ising model with three-spin interaction on kagome lattice.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/kagome_m.png" width="400" height="250"/>

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/kagome_E.png" width="400" height="250"/>


* Baxter_Wu.jl : code for checking if our result of Ising model on kagome lattice is correct.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/Baxter_Wu.png" width="400" height="250"/>

We conducted the finite size scaling for the Baxter-Wu model, and checked that our code identified the universality class of Baxter-Wu model properly.

Available functions for the codes are in 'MonteCarlo.jl' within same directory.


## Eigenvector

* eig_nr.jl : code for diagonalization of transition matrix, where there is no self-loop.

* L6_eig.cpp : code (Stern Judigng rule) for conducting power-method including self-loop.

* L4_eig.cpp :  code (L4 rule) for conducting power-method including self-loop.

## LTD, Heat_bath_Heider

There are codes for reproducing the results of papers which are regarding our subjects.
