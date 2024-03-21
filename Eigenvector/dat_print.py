import numpy as np

dat_L6 = np.loadtxt("./dat/N4L6_e0.0001t1000")
dat_L4 = np.loadtxt("./dat/N4L4_e0.0001t1000")

dat_L6 = dat_L6.T
dat_L4 = dat_L4.T

np.savetxt("./N4L6e-4t_histo.dat", dat_L6)
np.savetxt("./N4L4e-4t_histo.dat", dat_L4)
