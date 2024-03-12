import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import sys

if (len(sys.argv) < 3):
    print("python3 Markov.py N rule_idx flip_idx")
    exit(1)

N = int(sys.argv[1])
rule_idx = int(sys.argv[2])
flip_idx = int(sys.argv[3])
num = np.power(2, N*(N-1)) # ex) N=4 : 4096

group_set = []
with open("./N{}_permute.dat".format(N), "r") as file:
    for line in file:
        group_set.append(list(map(int, line.split())))

dat = np.loadtxt("./network_flip/N{}L{}_flip{}.dat".format(N,rule_idx,flip_idx))

dict_group = {}
dat_len = 0
for idx, element in enumerate(group_set):
#    print(idx)
    dict_group[idx] = element
#    dat_len += len(element)
#    print(element)
    
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

edge_weights = [G[u][v]['weight'] for u, v in G.edges()]
color_map = []
for node in G.nodes():
#    print(node)
    for group_idx, nodes in dict_group.items():
        if node in nodes:
            color_map.append(group_idx)
            break

mapping_color = {}
new_idx = 1
for num in color_map:
    if num not in mapping_color:
        mapping_color[num] = new_idx
        new_idx += 1

mapped_list = [mapping_color[num] for num in color_map]

print(mapped_list)
print(len(G.nodes()))
print(G.nodes())
print(len(G.nodes()))
pos = nx.spring_layout(G)
degrees = [20*G.degree[node] for node in G.nodes()]
#print(len(degrees))
#print(len(G.nodes()))
#nx.draw_networkx_nodes(G, pos, node_size=degrees)

#for edge in G.edges(data='weight'):
#    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
pos = nx.spring_layout(G)
plt.title("N=5, L{}, index : {}".format(rule_idx,flip_idx))
nx.draw_networkx_edges(G, pos=pos, width=edge_weights, arrows=True)
nx.draw_networkx_nodes(G, pos=pos, node_color=mapped_list, cmap=plt.cm.gist_ncar)
#nx.draw_networkx_nodes(G, pos=pos, node_color=color_map, cmap=plt.cm.jet)

nx.draw_networkx_labels(G, pos=pos, labels={n: str(n) for n in G.nodes()}, font_color='black')

plt.show()

