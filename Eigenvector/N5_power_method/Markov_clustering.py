import networkx as nx
from networkx.algorithms import similarity
from sklearn.cluster import KMeans
import numpy as np
import matplotlib.pyplot as plt
import sys

if (len(sys.argv) < 3):
	print("python3 Markov.py N rule_idx flip_idx")
	exit(1)

N = int(sys.argv[1])
rule_idx = int(sys.argv[2])
idx = int(sys.argv[3])

num = np.power(2, N*(N-1)) # 4096

group_nodes = 21  # this must be replaced with proper number
kmeans = KMeans(n_cluster = group_nodes)

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

similarity_mat = simliarity.graph_edit_distance(G, G)
cluster_labels = kmeans.fit_predict(similiarty_mat)

for node, cluster_label in zip(G.nodes(), cluster_labels):
	G.nodes[node]['cluster'] = cluster_label

pos = nx.spring_layout(G)
degrees = [20*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)

for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

node_colors = [cluster_label for _, cluster_label in nx.get_node_atributes(G,'cluster').items()]

nx.draw_networkx_labels(G, pos, font_size=10)
nx.draw(G, with_labels = True, node_color= node_colors, cmap=plt.cm.tab10)

plt.axis("off")
plt.title("N=5, L{}, index : {}".format(rule_idx,idx))
plt.show()
