import numpy as np
import matplotlib.pyplot as plt

p = np.linspace(0.1,1.0,10)

L6_15 = np.loadtxt("N15L6.dat")[:,1]
yerr_L6_15 = np.loadtxt("N15L6.dat")[:,2]

L6_17 = np.loadtxt("N17L6.dat")[:,1]
yerr_L6_17 = np.loadtxt("N17L6.dat")[:,2]

L6_19 = np.loadtxt("N19L6.dat")[:,1]
yerr_L6_19 = np.loadtxt("N19L6.dat")[:,2]

L6_21 = np.loadtxt("N21L6.dat")[:,1]
yerr_L6_21 = np.loadtxt("N21L6.dat")[:,2]

L6_23 = np.loadtxt("N23L6.dat")[:,1]
yerr_L6_23 = np.loadtxt("N23L6.dat")[:,2]

data_arr = [L6_23, L6_21, L6_19, L6_17, L6_15]
err_arr = [yerr_L6_23, yerr_L6_21, yerr_L6_19, yerr_L6_17, yerr_L6_15]
N_arr = [23,21,19,17,15]
c_arr = ["gold", "orange", "skyblue", "green", "purple"]

for i in range(5):
    N = N_arr[i]
    plt.plot(p,N*N*p*data_arr[i],label="N = {}".format(N),color="{}".format(c_arr[i]),marker='s')
    plt.errorbar(p,N*N*p*data_arr[i],yerr=N*N*p*err_arr[i],color="{}".format(c_arr[i]))

plt.xlabel("connection probability",fontsize=17)
plt.ylabel("fixation time",fontsize=17)
plt.title("Stern judging, 1000 realizations (random squential)",fontsize=16)

plt.xlim(0.1,1.0)
plt.yscale('log')
#plt.ylim([10,1E7])
plt.xticks(np.arange(0.1,1.1,0.1),fontsize=17)
plt.yticks(fontsize=15)
plt.legend(loc='upper left',fontsize=14)
plt.show()