# Exact Cluster Dynamics of Indirect Reciprocity in Complete Graphs

These are simulation codes that generate numerical results of the paper :

'Exact Cluster Dynamics of Indirect Reciprocity in Complete Graphs' (M. Bae, T. Shimada, S. K. Baek).

**PRE(Letter)** : https://journals.aps.org/pre/abstract/10.1103/PhysRevE.110.L052301

**arXiv link** : https://arxiv.org/abs/2404.15664

<br/>

## Eigenvector (C++)

The codes for conducting power-method to obtain the stationary probability distribution and probability flow.

## Ising (Julia)

The codes for Monte Carlo simulation of Ising model with three-spin interaction on various lattice structures.

I conducted the finite size scaling for the Baxter-Wu model, and checked that our code identified the universality class of Baxter-Wu model properly.
  

The description of each directory in **'Agent_based_model'** is below.

## network-simulation (C++, Julia)

There are codes for agent-based simulation of L6 (Stern Judging) and L4 rule.

Available functions for the codes are in 'Indirect_network.jl'

## LTD, Heat_bath_Heider (Julia)

There are codes for reproducing the results of papers regarding our subjects.

