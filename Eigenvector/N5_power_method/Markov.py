import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import sys

rule_idx = int(sys.argv[1])
idx = int(sys.argv[2])
N = 5
num = np.power(2, N*(N-1)) # 4096

dat = np.loadtxt("./network_flip/N5L{}_flip{}.dat".format(rule_idx,idx))

fr_L4 = np.zeros(num)
to_L4 = np.zeros(num)
prob_L4 = np.zeros(num)

for i in range(len(dat)):
	fr_L4[i] = int(dat[i,0])
	to_L4[i] = int(dat[i,1])
	prob_L4[i] = float(dat[i,2])

G = nx.DiGraph()
for i in range(len(dat)):
    fr = fr_L4[i]
    to = to_L4[i]
    G.add_edge(int(fr),int(to), weight = 15*prob_L4[i])  

pos = nx.spring_layout(G)
degrees = [20*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)

for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

nx.draw_networkx_labels(G, pos, font_size=10)
plt.axis("off")
plt.title("N=5, L{}, index : {}".format(rule_idx,idx))
plt.show()
