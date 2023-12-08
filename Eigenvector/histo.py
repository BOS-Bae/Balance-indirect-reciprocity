import matplotlib.pyplot as plt
import numpy as np
import sys

N = 4
err = 0.01
t=5
L6_elements = np.loadtxt("N{}L6_e{}t{}".format(N,err,t))
L4_elements = np.loadtxt("N{}L4_e{}t{}".format(N,err,t))

L6_elements /= np.sum(L6_elements)
L4_elements /= np.sum(L4_elements)

num = np.power(2,N*N)

print("L6 :")
for i in range(num):
    if (L6_elements[i] > 0.0025):
        print(i)

print("L4 :")
for i in range(num):
    if (L4_elements[i] > 0.0013):
        print(i)

plt.hist(L6_elements, bins=200, label='L6, N={}, err=0.01, bins=70'.format(N),color="blue")
plt.legend()
plt.yscale('log')
plt.show()

plt.hist(L4_elements, bins=200, label='L4, N={}, err=0.01, bins=70'.format(N),color="blue")
plt.legend()
plt.yscale('log')
plt.show()
