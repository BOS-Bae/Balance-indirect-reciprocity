import matplotlib.pyplot as plt
import numpy as np
import sys
import networkx as nx

N = int(sys.argv[1])
norm = int(sys.argv[2])
err = float(sys.argv[3])

N_mat = 2**(int(N*(N-1)/2))
Mat = np.loadtxt('N{}eig.dat'.format(N), delimiter=' ', usecols=range(N_mat))

plt.matshow(Mat,cmap='cividis')
plt.colorbar()
plt.title("L{}, err = {}".format(norm, err))
print(Mat)
plt.show()