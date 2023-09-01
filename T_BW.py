import numpy as np
import matplotlib.pyplot as plt
import sys

L = int(sys.argv[1])
T_sl = 50
N = L*L
dat = np.loadtxt("L{}_BW.dat".format(L), usecols=range(T_sl),delimiter=" ")

#dat_4 = np.loadtxt("L4_BW.dat", usecols=range(T_sl),delimiter=" ")
#dat_6 = np.loadtxt("L6_BW.dat", usecols=range(T_sl),delimiter=" ")
#dat_10 = np.loadtxt("L10_BW.dat", usecols=range(T_sl),delimiter=" ")
T = dat[0]
E = dat[1]
c = (dat[2] - dat[1]**2)/(dat[0]**2)

print(dat[3])

plt.plot(T,E,label="energy", color="blue")
plt.plot(T,N*c,label="specific heat", color="lightseagreen")
#plt.plot(T,dat_4[1],label="L=4", color="cyan")
#plt.plot(T,dat_6[1],label="L=6", color="blue")
#plt.plot(T,dat_10[1],label="L=10", color="darkblue")

plt.xlabel("T")
plt.legend()
plt.title("L={}, Baxter & Wu model".format(L))
#plt.title("Energy, Baxter & Wu model")
plt.ylim([-2,2.5])
plt.show()