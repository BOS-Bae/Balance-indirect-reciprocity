import numpy as np
import matplotlib.pyplot as plt
import sys

Lx = int(sys.argv[1])
Ly = int(sys.argv[2])
dat = np.loadtxt("KagomeLx{}Ly{}.dat".format(Lx,Ly), usecols=range(4), delimiter=" ")

p_spin = []
m_spin = []

for i in range(3*Lx*Ly):
    row = dat[i][1]
    col = dat[i][2]
    spin = dat[i][3]
    if (spin == 1):
        p_spin.append([row,col])
    elif (spin == -1):
        m_spin.append([row,col])
            
print(m_spin,"\n")
print(p_spin,"\n")
for i in range(3*Lx*Ly):
    print(dat[i][0]," ", dat[i][1]," ", dat[i][2])

for p in p_spin:
    plt.scatter(p[1], p[0], color="blue", s=50,  marker='o')
for m in m_spin:
    plt.scatter(m[1], m[0], color="tomato", s=50, marker='o')

plt.title("kagome(Lx={}, Ly={}) : blue : +, red : -".format(Lx,Ly))
plt.show()
