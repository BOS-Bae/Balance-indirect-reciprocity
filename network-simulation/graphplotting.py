import numpy as np
import matplotlib.pyplot as plt
import networkx as nx

N = 10
rule_num = 8
network=np.ones([N,N])

action = np.loadtxt("./N{}_image_mat.dat".format(N))

plus=0
negative=0

for i in range(N):
    for j in range(N):
        if action[i,j] == 1:
            plus+=1
        elif action[i,j] == -1:
            negative+=1
        

print("plus(%)=",plus/(N*N))
print("negative(%)=",negative/(N*N))

fig,ax=plt.subplots()
im=ax.imshow(action,cmap='gray')
plt.title("N={}, L{} rule".format(N, rule_num))
plt.show()


G=nx.Graph()

for i in range(N):
    for j in range(N):
        if action[i,j]==1:
            G.add_edge("{}".format(i),"{}".format(j),weight=1)
        elif action[i,j]==-1:
            G.add_edge("{}".format(i),"{}".format(j),weight=-1)
            
eplus = [(u,v) for (u,v,d) in G.edges(data=True) if d["weight"]==1]
eminus = [(u,v) for (u,v,d) in G.edges(data=True) if d["weight"]==-1]

pos = nx.spring_layout(G)

nx.draw_networkx_edges(G,pos=pos,edgelist=eplus,width=5,alpha=0.5,edge_color="b")
nx.draw_networkx_edges(G,pos=pos,edgelist=eminus,width=5,alpha=0.5,edge_color="r")

nx.draw_networkx(G,pos)
plt.axis("off")
plt.tight_layout()
plt.title("N={}, L{} rule".format(N, rule_num))
plt.show()
#
#G.remove_edges_from(eminus)
#
#nx.draw_networkx_edges(G,pos=pos,edgelist=eplus,width=5,alpha=0.5,edge_color="b")
#
#nx.draw_networkx(G,pos)
#
#plt.axis("off")
#plt.tight_layout()
#plt.show()