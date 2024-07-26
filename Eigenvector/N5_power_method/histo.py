import matplotlib.pyplot as plt
import numpy as np
import sys 

if (len(sys.argv) < 3):
    print("python3 histo.py N t err")
    exit(1)

f_s = 12
N = int(sys.argv[1])
t = int(sys.argv[2])
err = float(sys.argv[3])
#L4_elements = np.loadtxt("./N{}L4_e-2147483648t{}.dat".format(N,t))
#L6_elements = np.loadtxt("./N{}L6_e-2147483648t{}.dat".format(N,t))

#L4_elements = np.loadtxt("./N{}L4_e{}t{}.dat".format(N,int(np.log10(err)),t))
L6_elements = np.loadtxt("./N{}L6_e{}t{}.dat".format(N,int(np.log10(err)),t))

#print("L4 sum : ", np.sum(L4_elements), "\n")
#L4_elements /= np.sum(L4_elements)

print("L6 sum : ", np.sum(L6_elements), "\n")
L6_elements /= np.sum(L6_elements)

num = np.power(2, N*N)

#print("L4 :")
#for i in range(num):
#    if (L4_elements[i] > 0.003):
#        print(i, "    ", L4_elements[i])
#print("")
print("L6 :")
for i in range(num):
    if (L6_elements[i] > 0.003):
        print(i, "    ", L6_elements[i])
#print(0, "  ", L4_elements[0])
#print(0, "  ", L6_elements[0])

#plt.hist(L4_elements, bins=30, label='L4, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
#plt.legend(fontsize=f_s)
#plt.yscale('log')
#plt.yticks(fontsize=f_s)
#plt.xticks(fontsize=f_s)
#plt.xlim(0,1.0)
#plt.savefig('./L4_eigen.pdf', format='pdf')
#
#plt.show()

plt.hist(L6_elements, bins=30, label='L6, N={}, err={}, {} multiplication'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.savefig('./L6_eigen.pdf', format='pdf')

plt.show()
