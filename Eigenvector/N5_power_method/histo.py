import matplotlib.pyplot as plt
import numpy as np
#import sys

#if (len(sys.argv) < 3):
#    print("usage : N err iter")
#    exit(1)

f_s = 12
#N = int(sys.argv[1])
#err = sys.argv[2]
#t = int(sys.argv[3])
N = 6
err = 0.0001
t = 1000

L6_elements = np.loadtxt("./N{}L6_e{}t{}.dat".format(N,err,t))
L4_elements = np.loadtxt("./N{}L4_e{}t{}.dat".format(N,err,t))

print("L6 sum : ", np.sum(L6_elements), "\n")
print("L4 sum : ", np.sum(L4_elements) ,"\n")
L6_elements /= np.sum(L6_elements)
L4_elements /= np.sum(L4_elements)

num = np.power(2,N*N)

print("L6 :")
for i in range(num):
    if (L6_elements[i] > 0.01):
        print(i)

print("\nL4 :")
for i in range(num):
    if (L4_elements[i] > 0.4):
        print(i)

plt.hist(L6_elements, bins=20, label='L6, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.show()

#plt.savefig('./L6_eigen.eps', format='eps')

plt.hist(L4_elements, bins=100, label='L4, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.show()

#plt.savefig('./L4_eigen.eps', format='eps')