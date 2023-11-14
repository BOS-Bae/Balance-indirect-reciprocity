import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

N = 4
num = np.power(2, N*(N-1)) # 4096

net_L4 = np.loadtxt("mat_N4L4_e0.01")
net_L6 = np.loadtxt("mat_N4L6_e0.01")

cut = 15

eigen_L4 = np.loadtxt("N4L4_eigen.dat")
eigen_L6 = np.loadtxt("N4L6_eigen.dat")

G = nx.DiGraph()
for i in eigen_L4:
    for j in eigen_L4[:cut]:
        if (net_L4[int(j),int(i)] > 0):
            G.add_edge("{}".format(int(i+1)),"{}".format(int(j+1)), weight = 40*net_L4[int(j),int(i)])

print("ok", "\n")

pos = nx.spring_layout(G)
degrees = [50*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)
nx.draw_networkx_labels(G, pos, font_size=10)

print("?")
for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
plt.title("L4 : transition network")
plt.show()


G = nx.DiGraph()
for i in eigen_L6:
    for j in eigen_L6[:cut]:
        if (net_L6[int(j),int(i)] > 0):
            G.add_edge("{}".format(int(i+1)),"{}".format(int(j+1)), weight = 40*net_L6[int(j),int(i)])

print("ok", "\n")

pos = nx.spring_layout(G)
degrees = [50*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)
nx.draw_networkx_labels(G, pos, font_size=10)

print("?")
for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
plt.title("L6 : transition network")
plt.show()

