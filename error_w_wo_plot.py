import numpy as np
import matplotlib.pyplot as plt
import sys

N_agent = int(sys.argv[1])
e_prob = float(sys.argv[2])
n_sample = int(sys.argv[3])

p = np.linspace(0.1,1.0,10)

N15_dat = np.loadtxt("N{}e{}n{}.dat".format(N_agent, 0, n_sample), usecols=range(10), delimiter=" ")
N15_error_dat = np.loadtxt("N{}e{}n{}.dat".format(N_agent, e_prob, n_sample), usecols=range(10), delimiter=" ")

plt.plot(p,N15_dat[0, :],label="No error",color="lightseagreen",marker='o')
plt.errorbar(p,N15_dat[0, :],yerr=N15_dat[1, :],color="lightseagreen")

plt.plot(p,N15_error_dat[0, :],label="err = 0.01",color="blue",marker='o')
plt.errorbar(p,N15_error_dat[0, :],yerr=N15_error_dat[1, :],color="blue")

plt.legend()
plt.xlabel("p")
plt.ylabel("fixation time")
plt.title("N=15, Error effect for L6")
plt.show()

print(N15_error_dat[0,:])
