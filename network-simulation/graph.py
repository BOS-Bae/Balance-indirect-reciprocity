import numpy as np
import matplotlib.pyplot as plt

N_f = 40
n_sample = 50

L6_dat = np.loadtxt("L6_N{}_s{}_cluster.dat".format(N_f,n_sample))
L4_dat = np.loadtxt("L4_N{}_s{}_cluster.dat".format(N_f,n_sample))

N_arr = L6_dat[0,:]
Diff_arr_L6 = L6_dat[1,:]
Diff_arr_L4 = L4_dat[1,:]
std_err_L6 = L6_dat[1,:]
std_err_L4 = L4_dat[2,:]

idx=0
for n in N_arr:
    Diff_arr_L6[idx] /= n
    std_err_L6[idx] /= n
    Diff_arr_L4[idx] /= n
    std_err_L4[idx] /= n
    idx += 1

plt.plot(N_arr, Diff_arr_L6,color="midnightblue",marker='s')
plt.errorbar(N_arr, Diff_arr_L6,yerr=std_err_L6,color="midnightblue")
plt.xlabel("N",fontsize=15)
plt.ylabel("δ/N",fontsize=15)
plt.xlim(3,N_f)
plt.title("L6",fontsize=15)
plt.ylim(0,1)
plt.show()

plt.plot(N_arr, Diff_arr_L4,color="blue",marker='s')
plt.errorbar(N_arr, Diff_arr_L4,yerr=std_err_L4,color="blue")
plt.xlabel("N",fontsize=15)
plt.ylabel("δ/N",fontsize=15)
plt.xlim(3,N_f)
plt.title("L4",fontsize=15)
plt.ylim(0,1)
plt.show()
