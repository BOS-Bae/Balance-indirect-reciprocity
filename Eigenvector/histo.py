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

print("L7 sum : ", np.sum(L7_elements), "\n")
L7_elements /= np.sum(L7_elements)

num = np.power(2, N*N)

print("L7 :")
for i in range(num):
    if (L7_elements[i] > 0.005):
        print(i, "    ", L7_elements[i])

plt.hist(L7_elements, bins=20, label='L7, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.savefig('./L7_eigen.pdf', format='pdf')

plt.show()
