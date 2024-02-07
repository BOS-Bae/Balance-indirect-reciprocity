import matplotlib.pyplot as plt
import numpy as np

f_s = 12
N = 4
err = 0.0001
t = 1000

L6_elements = np.loadtxt("./N{}L6_e{}t{}.dat".format(N,int(np.log10(err)),t))
L4_elements = np.loadtxt("./N{}L4_e{}t{}.dat".format(N,int(np.log10(err)),t))

print("L6 sum : ", np.sum(L6_elements), "\n")
print("L4 sum : ", np.sum(L4_elements) ,"\n")
L6_elements /= np.sum(L6_elements)
L4_elements /= np.sum(L4_elements)

num = np.power(2, N*N)

print("L6 :")
for i in range(num):
    if (L6_elements[i] > 0.01):
        print(i, "    ", L6_elements[i])

print("\nL4 :")
for i in range(num):
    if (L4_elements[i] > 0.4):
        print(i, "    ", L4_elements[i])

plt.hist(L6_elements, bins=20, label='L6, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.savefig('./L6_eigen.pdf', format='pdf')

plt.clf()

plt.hist(L4_elements, bins=100, label='L4, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.savefig('./L4_eigen.pdf', format='pdf')
