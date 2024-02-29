import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

N = 4
num = np.power(2, N*(N-1)) # 4096

three_step = False # default : two_step

balance = [1,592,1210,1783,2515,2974,3426,3877]

for i in range(len(balance)):
    balance[i] -= 1

print(balance)  
net_L4 = np.loadtxt("mat_N4L4_e0.01")
net_L6 = np.loadtxt("mat_N4L6_e0.01")

cut = 200

eigen_L4 = np.loadtxt("N4L4_eigen.dat")
eigen_L6 = np.loadtxt("N4L6_eigen.dat")


G = nx.DiGraph()
for k in balance:
    for j in range(num):
        if (net_L4[int(k),int(j)] > 0) :
            if (i!=j): G.add_edge(int(j+1),int(k+1), weight = 100*net_L4[int(k),int(j)])  
#            else: G.add_edge(int(j+1),int(k+1), {'weight' : 100*net_L4[int(k),int(j)], 'self_loop' : True})  
            for i in range(num):
                if (net_L4[int(j),int(i)] > 0):
                    if (i!=j): G.add_edge("{}".format(int(i+1)),"{}".format(int(j+1)), weight = 30*net_L4[int(j),int(i)])  
#                    else: G.add_edge("{}".format(int(i+1)),"{}".format(int(j+1)), {'weight' : 100*net_L4[int(j),int(i)], 'self_loop' : True})  
                    if (three_step):
                        for m in range(num):
                            if (net_L4[int(i), int(m)] >0):
                                if (i!=j): G.add_edge("{}".format(int(m+1)),"{}".format(int(i+1)), weight = 10*net_L4[int(i),int(m)])  
#                                else: G.add_edge("{}".format(int(m+1)),"{}".format(int(i+1)), {'weight' : 100*net_L4[int(i),int(m)], 'self_loop' : True})  
#
#print("ok", "\n")
#for i in eigen_L4:
#    for j in eigen_L4:
#        for k in eigen_L4[:cut]:
#            if (net_L4[int(j), int(i)]*net_L4[int(k),int(j)] > 0 ):
#                G.append("{}".format(int(i+1)),"{}".format(int(k+1)), weight = 200*net_L4[int(k),int(j)]*net_L4[int(j),int(i)])
#
print("ok", "\n")

pos = nx.spring_layout(G)
degrees = [50*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)
nx.draw_networkx_labels(G, pos, font_size=10)

for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
plt.title("L4 : transition network")
plt.show()


G = nx.DiGraph()

for k in balance:
    for j in range(num):
        if (net_L6[int(k),int(j)] > 0) :
            if (i!=j): G.add_edge("{}".format(int(j+1)),"{}".format(int(k+1)), weight = 100*net_L6[int(k),int(j)])  
#            else: G.add_edge("{}".format(int(j+1)),"{}".format(int(k+1)), {'weight' : 100*net_L6[int(k),int(j)], 'self_loop' : True})  
            for i in range(num):
                if (net_L6[int(j),int(i)] > 0):
                    if (i!=j): G.add_edge("{}".format(int(i+1)),"{}".format(int(j+1)), weight = 30*net_L6[int(j),int(i)])  
#                    else: G.add_edge("{}".format(int(i+1)),"{}".format(int(j+1)), {'weight' : 100*net_L6[int(j),int(i)], 'self_loop' : True})  
                    if (three_step):
                        for m in range(num):
                            if (net_L6[int(i), int(m)] >0):
                                if (i!=j): G.add_edge("{}".format(int(m+1)),"{}".format(int(i+1)), weight = 10*net_L6[int(i),int(m)])  
#                                else :G.add_edge("{}".format(int(m+1)),"{}".format(int(i+1)), {'weight' : 100*net_L6[int(i),int(m)], 'self_loop' : True})  
'''
for k in balance:
    for j in range(num):
        if (net_L6[int(k),int(j)] > 0) :
            G.append("{}".format(int(j+1)),"{}".format(int(k+1)), weight = 100*net_L6[int(k),int(j)])  
            for i in range(num):
                if (net_L6[int(j),int(i)] > 0):
                    G.append("{}".format(int(i+1)),"{}".format(int(j+1)), weight = 30*net_L6[int(j),int(i)])
                    if (three_step):
                        for m in range(num):
                            if (net_L6[int(i), int(m)] >0):
                                G.append("{}".format(int(m+1)),"{}".format(int(i+1)), weight = 10*net_L6[int(i),int(m)])
print("ok", "\n")
'''
pos = nx.spring_layout(G)
degrees = [50*G.degree[node] for node in G.nodes()]
print(len(degrees))
print(len(G.nodes()))
nx.draw_networkx_nodes(G, pos, node_size=degrees)
nx.draw_networkx_labels(G, pos, font_size=10)

for edge in G.edges(data='weight'):
    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
plt.title("L6 : transition network")
plt.show()
