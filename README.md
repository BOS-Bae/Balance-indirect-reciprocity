# Exact Cluster Dynamics of Indirect Reciprocity in Complete Graphs

These are simulation codes which generate numerical results of the paper :

'Exact Cluster Dynamics of Indirect Reciprocity in Complete Graphs' (Minwoo Bae, Takashi Shimada, Seung Ki Baek).

**PRE(Letter)** : https://journals.aps.org/pre/abstract/10.1103/PhysRevE.110.L052301
**arXiv link** : https://arxiv.org/abs/2404.15664

## Eigenvector (C++)

The codes for conducting power-method to obtain stationary probability distribution and probability flow.

## Ising (Julia)

The codes for Monte Carlo simulation of Ising model with three-spin interaction on various lattice structures.

The Hamiltonian of each model is as follows:

$$
H=-\sum_{\Delta_{ijk}} \sigma_i \sigma_j \sigma_k
$$

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/kagome_m.png" width="400" height="250"/>

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/kagome_E.png" width="400" height="250"/>

I conducted the finite size scaling for the Baxter-Wu model, and checked that our code identified the universality class of Baxter-Wu model properly.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/Baxter_Wu.png" width="400" height="250"/>
  

The description of each directory in **'Agent_based_model'** is below.

## network-simulation (C++, Julia)

There are codes for agent-based simulation of Stern Judging rule and L4 rule.

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/L6_fixation.png" width="400" height="250"/>

<img src="https://github.com/BOS-Bae/Balance-indirect-reciprocity/blob/main/fig/L4_fixation.png" width="400" height="250"/>

Available functions for the codes are in 'Indirect_network.jl'

## LTD, Heat_bath_Heider (Julia)

There are codes for reproducing the results of papers regarding our subjects.

