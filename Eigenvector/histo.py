import matplotlib.pyplot as plt
import numpy as np
import sys 

if (len(sys.argv) < 2):
    print("python3 histo.py N t")
    exit(1)

f_s = 12
N = int(sys.argv[1])
err = 0.0001
t = int(sys.argv[2])

L7_elements = np.loadtxt("./N{}L7_e{}t{}.dat".format(N,int(np.log10(err)),t))
L8_elements = np.loadtxt("./N{}L8_e{}t{}.dat".format(N,int(np.log10(err)),t))

print("L7 sum : ", np.sum(L7_elements), "\n")
L7_elements /= np.sum(L7_elements)

print("L8 sum : ", np.sum(L8_elements), "\n")
L8_elements /= np.sum(L8_elements)

num = np.power(2, N*N)

print("L7 :")
for i in range(num):
    if (L7_elements[i] > 0.003):
        print(i, "    ", L7_elements[i])
print("")
print("L8 :")
for i in range(num):
    if (L8_elements[i] > 0.003):
        print(i, "    ", L8_elements[i])
print(0, "  ", L7_elements[0])
print(0, "  ", L8_elements[0])

plt.hist(L7_elements, bins=30, label='L7, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.savefig('./L7_eigen.pdf', format='pdf')

plt.show()

plt.hist(L8_elements, bins=30, label='L8, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.savefig('./L8_eigen.pdf', format='pdf')

plt.show()
