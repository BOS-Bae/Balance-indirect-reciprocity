import matplotlib.pyplot as plt
import numpy as np
import sys

if (len(sys.argv) < 3):
    print("usage : N err iter")
    exit(1)

f_s = 12
N = int(sys.argv[1])
err = sys.argv[2]
t = int(sys.argv[3])
L6_elements = np.loadtxt("./dat/N{}L6_e{}t{}".format(N,err,t))
L4_elements = np.loadtxt("./dat/N{}L4_e{}t{}".format(N,err,t))

val = 0
if (t==1): val = 0.000173
elif (t==3): val = 0.002
elif (t==5) : val = 0.005
#elif (t==10) : val =0.02
elif (t==10) : val =0.05
elif (t==20) : val =0.05
elif (t>=30) : val =0.1

print("L6 sum : ", np.sum(L6_elements), "\n")
print("L4 sum : ", np.sum(L4_elements) ,"\n")
L6_elements /= np.sum(L6_elements)
L4_elements /= np.sum(L4_elements)

num = np.power(2,N*N)

print("L6 :")
for i in range(num):
    if (L6_elements[i] > val):
        print(i)

print("\nL4 :")
for i in range(num):
    if (L4_elements[i] > val):
        print(i)

plt.hist(L6_elements, bins=20, label='L6, N={}, err={}, {} multiplied'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.show()

plt.hist(L4_elements, bins=50, label='L4, N={}, err={}, {} multiplied'.format(N,err,t),color="blue")
plt.legend(fontsize=f_s)
plt.yscale('log')
plt.yticks(fontsize=f_s)
plt.xticks(fontsize=f_s)
plt.xlim(0,1.0)
plt.show()
