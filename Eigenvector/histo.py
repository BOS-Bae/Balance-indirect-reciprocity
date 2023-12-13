import matplotlib.pyplot as plt
import numpy as np
import sys

if (len(sys.argv) < 3):
    print("usage : N err iter")
    exit(1)

N = int(sys.argv[1])
err = sys.argv[2]
t = sys.argv[3]
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
    if (L4_elements[i] > 0.0025):
        print(i)

plt.hist(L6_elements, bins=100, label='L6, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend()
plt.yscale('log')
#plt.xlim(0,0.02)
plt.show()

plt.hist(L4_elements, bins=100, label='L4, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend()
plt.yscale('log')
#plt.xlim(0,0.02)
plt.show()
