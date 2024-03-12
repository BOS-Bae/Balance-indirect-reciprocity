import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
import sys

iter_time = int(sys.argv[1])

G = nx.DiGraph()
for i in range(iter_time):
	G.add_edge(2,1)

pos = nx.spring_layout(G)
nx.draw_networkx_nodes(G,pos)
nx.draw_networkx_labels(G,pos)

for edge in G.edges:
	nx.draw_networkx_edges(G,pos,edgelist=[edge])

plt.axis("off")
plt.show()
