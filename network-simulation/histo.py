import matplotlib.pyplot as plt
import numpy as np
import sys

N = 4
err = 0
iter= 100000
L4_elements = np.loadtxt("N4_L4_config.dat")
y, x, _ = plt.hist(L4_elements)
y= np.array(y)
print(x)
print(y)
#plt.hist(L4_elements, bins=200, label='L4, N={}, err={}, 1E5 runs, complete graph'.format(N,err),color="blue")
plt.plot(x, y/iter)
axes = plt.gca()
plt.legend()
plt.yscale('log')
plt.show()
