# Exact Cluster Dynamics of Indirect Reciprocity in Complete Graphs

These are simulation codes which generate numerical results of the paper : 'Exact Cluster Dynamics of Indirect Reciprocity in Complete Graphs'.


arXiv link : https://arxiv.org/abs/2404.15664

## Eigenvector

* eig_nr.jl : code for diagonalization of the transition matrix, where there is no self-loop.

* L6_eig.cpp : code (Stern Judigng rule) to conduct power-method including self-loop.

* L4_eig.cpp :  code (L4 rule) to conduct power-method including self-loop from $t=0$.

* L6_eig_r.cpp / L4_eig_r.cpp : codes to conduct power-method including self-loop from $t=t_0 \ne 0$.

* L6_M.cpp / L4_M.cpp : codes to conduct power-method including self-loop and get each probability from one balanced state to other ones.

## Ising

* kagome.jl : code for Monte Carlo simulation of Ising model with three-spin interaction on kagome lattice.

$$
H=-\sum_{\Delta_{ijk}} \sigma_i \sigma_j \sigma_k
$$

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/kagome_m.png" width="400" height="250"/>

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/kagome_E.png" width="400" height="250"/>


* Baxter_Wu.jl : code for checking if our result of Ising model on kagome lattice is correct.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/Baxter_Wu.png" width="400" height="250"/>

We conducted the finite size scaling for the Baxter-Wu model, and checked that our code identified the universality class of Baxter-Wu model properly.

Available functions for the codes are in 'MonteCarlo.jl' within same directory.


The description of each directory in 'Agent_based_model' is below.

## network-simulation

There are codes for agent-based simulation of Stern Judging rule and L4 rule.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/L6_fixation.png" width="400" height="250"/>

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/L4_fixation.png" width="400" height="250"/>

Available functions for the codes are in 'Indirect_network.jl'

## LTD, Heat_bath_Heider

There are codes for reproducing the results of papers which are regarding our subjects.

* LTD : for local triad dynamics

* Heat_bath_Heider : for Heider-rule applied model on complete graph
