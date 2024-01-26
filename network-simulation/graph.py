import numpy as np
import matplotlib.pyplot as plt

N_f = 60
n_sample = 50

L6_dat = np.loadtxt("L6_N{}_s{}_cluster.dat".format(N_f,n_sample))
L4_dat = np.loadtxt("L4_N{}_s{}_cluster.dat".format(N_f,n_sample))
#more_dat = np.loadtxt("tes_L6")
#print(L6_dat)

N_arr = L6_dat[0,:]
Diff_arr_L6 = L6_dat[1,:]
std_err_L6 = L6_dat[2,:]
Diff_arr_L4 = L4_dat[1,:]
std_err_L4 = L4_dat[2,:]

plt.plot(N_arr, Diff_arr_L6,color="midnightblue",marker='s')
plt.errorbar(N_arr, Diff_arr_L6,yerr=std_err_L6,color="midnightblue",capsize=8)
plt.xlabel("N",fontsize=25)
plt.ylabel("η/N",fontsize=25)
plt.title("(a)",fontsize=35)
plt.xlim(3,N_f)
plt.ylim(-1,1)
plt.show()

plt.plot(N_arr, Diff_arr_L4,color="blue",marker='s')
plt.errorbar(N_arr, Diff_arr_L4,yerr=std_err_L4,color="blue",capsize=8)
plt.xlabel("N",fontsize=25)
plt.ylabel("η/N",fontsize=25)
plt.xlim(3,N_f)
plt.ylim(-1,1)
plt.title("(b)",fontsize=35)
plt.show()