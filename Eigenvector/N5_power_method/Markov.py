import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import sys

idx = int(sys.argv[1])
N = 5
num = np.power(2, N*(N-1)) # 4096

dat_L4 = np.loadtxt("./network_flip/N5L4_flip{}.dat".format(idx))

fr_L4 = np.zeros(num)
to_L4 = np.zeros(num)
prob_L4 = np.zeros(num)

for i in range(len(dat_L4)):
	fr_L4[i] = int(dat_L4[i,0])
	to_L4[i] = int(dat_L4[i,1])
	prob_L4[i] = float(dat_L4[i,2])

G = nx.DiGraph()
for i in range(len(dat_L4)):
    fr = fr_L4[i]
    to = to_L4[i]
    G.add_edge(int(fr),int(to), weight = 30*prob_L4[i])  

pos = nx.spring_layout(G)
degrees = [10*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)
nx.draw_networkx_labels(G, pos, font_size=10)

for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
plt.title("N=5, L4, flip {}".format(idx))
plt.show()
