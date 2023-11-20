import matplotlib.pyplot as plt
import numpy as np
import sys
import networkx as nx

L = int(sys.argv[1])
M = int(sys.argv[2])
Lat = np.loadtxt('L{}M1E8_1E6MCS.dat'.format(L), delimiter=' ', usecols=range(2*L))

#print(Lat)
plt.matshow(Lat,cmap='cividis')
plt.colorbar()
plt.title("L={}, M=1E{}".format(L,M))
plt.show()

'''
G=nx.Graph()

for i in range(2*L):
    Lat[i,i] = 0
    
for i in range(2*L):
    for j in range(2*L):
        if Lat[i,j]==1:
            G.add_edge("{}".format(i),"{}".format(j),weight=1)
        elif Lat[i,j]==-1:
            G.add_edge("{}".format(i),"{}".format(j),weight=-1)
            
eplus = [(u,v) for (u,v,d) in G.edges(data=True) if d["weight"]==1]
eminus = [(u,v) for (u,v,d) in G.edges(data=True) if d["weight"]==-1]



pos = nx.spring_layout(G)

nx.draw_networkx_edges(G,pos=pos,edgelist=eplus,width=5,alpha=0.5,edge_color="b")
nx.draw_networkx_edges(G,pos=pos,edgelist=eminus,width=5,alpha=0.5,edge_color="r")

nx.draw_networkx(G,pos)


plt.axis("off")
plt.tight_layout()
plt.show()
'''