import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import sys

problem = [9594, 9604]

if (len(sys.argv) < 4):
	print("python3 Markov.py N rule_idx flip_idx group_cut")
	exit(1)

N = int(sys.argv[1])
rule_idx = int(sys.argv[2])
flip_idx = int(sys.argv[3])
group_cut = int(sys.argv[4])
num = np.power(2, N*(N-1)) # ex) N=4 : 4096

group_set = []
with open("./N{}_permute.dat".format(N), "r") as file:
	for line in file:
		group_set.append(list(map(int, line.split())))

dat = np.loadtxt("./network_flip/N{}L{}_flip{}.dat".format(N,rule_idx,flip_idx))

dict_group = {}
dat_len = 0
for idx, element in enumerate(group_set):
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
  if (fr!=to): G.add_edge(int(fr),int(to), weight = prob_L4[i])

#print(len(list(G.nodes())))
edge_weights = [G[u][v]['weight'] for u, v in G.edges()]
color_map = []
group_info = []
for i in G.nodes():
	for group_idx, nodes in dict_group.items():
		if i in nodes:
			group_info.append((i,group_idx))
			color_map.append(group_idx)
			break

group_info = dict(group_info)
check_list = []
for i, j in G.edges():
	group_i = group_info[i]
	group_j = group_info[j]
	prob = G.get_edge_data(i,j)['weight']
#	if (group_i == problem[0] and group_j == problem[1]):
#		print(i, j, prob)
	check_list.append([group_i, group_j, prob])

group_list = []
for i in range(len(dat)):
	node_i = to_L4[i]
	group_i = group_info[node_i]
	if (group_i not in group_list):
		group_list.append(group_i)

big_node = []
step = 0
for arr in check_list:
	count = 0
	big_node.append(arr)
	for arr2 in big_node:
		if (arr != arr2) : count += 1
	if (count == len(big_node)):
		big_node.append(arr)
	step += 1
#print(big_node)

check_true = 0
count_idx = 0
'''
for arr in check_list:
	count_idx += 1
	
	fr = arr[0]
	to = arr[1]
	count = 0
	check = 0
	for arr_big in big_node:
		fr_big = arr_big[0]
		to_big = arr_big[1]
		if (fr == fr_big and to == to_big):
			count += 1
			if (arr[2] == arr_big[2]):
				check += 1
			#else :
			#	print(arr)
			#	print(arr_big)
	if (count == check):
		#print(count)
		check_true += 1

#print(check_true == count_idx)
'''
mapping_color = {}
new_idx = 1
for num in color_map:
	if num not in mapping_color:
		mapping_color[num] = new_idx
		new_idx += 1

G.clear()

G = nx.DiGraph()

group_arr = group_list[0:group_cut]

pair_list = []
node_list = []
for i in range(len(dat)):
	fr = int(fr_L4[i])
	to = int(to_L4[i])
	node_i = fr
	node_j = to
	for g in group_arr:
		if (group_info[int(fr)] == int(g)): 
#     print(fr, g)
			node_i = int(num + 1 + g)
		if (group_info[int(to)] == int(g)): 
#			print(to, g)
			node_j = int(num + 1 + g)
	arr = [node_i, node_j]
	if (node_i not in node_list): node_list.append(node_i)
	if (node_j not in node_list): node_list.append(node_j)
	if (arr not in pair_list):
		pair_list.append(arr)
		G.add_edge(int(node_i),int(node_j), weight = prob_L4[i])
'''
for i in range(len(big_node)):
	fr = big_node[i][0]
	to = big_node[i][1]
	prob = big_node[i][2]
	if (fr!=to): G.add_edge(int(fr),int(to), weight = prob)
'''

edge_weights = [G[u][v]['weight'] for u, v in G.edges()]
edge_weights_label = ["{}".format(G[u][v]['weight']) for u, v in G.edges()]
curved_edges = [edge for edge in G.edges() if reversed(edge) in G.edges()]
straight_edges = list(set(G.edges()) - set(curved_edges))

#degrees = [20*G.degree[node] for node in G.nodes()]
#print(len(degrees))

#print(len(G.nodes()))

#pos = nx.kamada_kawai_layout(G)
pos = nx.spring_layout(G)
#pos = nx.planar_layout(G)
#for edge in G.edges(data='weight'):
#    nx.draw_networkx_edges(G,pos,edgelist=[edge],width=edge[2])

plt.axis("off")
#pos = nx.spectral_layout(G)
#pos = nx.spring_layout(G)
plt.title("N={}, L{}".format(N,rule_idx))
#nx.draw_networkx_edges(G, pos=pos, width=edge_weights, arrows=True)
nx.draw_networkx_edges(G, pos=pos, arrows=True)
#nx.draw_networkx_nodes(G, pos=pos, node_color=color_map, cmap=plt.cm.gist_ncar)
nx.draw_networkx_nodes(G, pos=pos, node_size = 300)

nx.draw_networkx_labels(G, pos=pos,font_size = 10, labels={n: str(n) for n in G.nodes()}, font_color='black')

#edge_labels = {(u, v): d['weight'] for u, v, d in G.edges(data=True)}
edge_labels = {(u, v): "{}/{}".format(int(N*N*d['weight']),N*N) for u, v, d in G.edges(data=True)}

check_arr = []
check_neigh = []

for i in G.nodes():
	prob_list = []
	node_i = i
	check_arr.append(i)
	print("q{}".format(i), " == ", "(", end="")
	for j in G.neighbors(i):
		if (j not in check_neigh):
			check_neigh.append(j)
		w_ij = G.get_edge_data(i, j)['weight']
		prob_list.append(w_ij)
		print("({}/{})".format(int(np.round(float(w_ij)*N*N,0)), int(N*N)), "*q{}".format(j), "+", end="")
	print("({}/{})".format(int(np.round((1-sum(prob_list))*N*N,0)), int(N*N)), "*q{}".format(i), ") && ")

print("{", end="")
for i in (set(check_arr).union(set(check_neigh))):
	print("q{}".format(i), "," ,end="")	
print("}")

for i in G.nodes():
	idx = 0
	for j in G.neighbors(i):
		idx += 1
	if (idx == 0): print(i)

'''
for arr in big_node:
	i = arr[0]
	prob_list = []
	if (i not in check_arr):
		check_arr.append(i)
		print("q{}".format(i), " == ", "(", end="")
		for j in G.neighbors(i):
			if (j not in check_neigh):
				check_neigh.append(j)
			w_ij = G.get_edge_data(i, j)['weight']
			prob_list.append(w_ij)
			print("({}/{})".format(int(w_ij*(float(N*N)), int(N*N)), "*q{}".format(j), "+", end=""))
		print("({}/{})".format(int((1-sum(prob_list))*float(N*N)), int(N*N)), "*q{}".format(i), ") && ")
print("{", end="")
for i in (set(check_arr).union(set(check_neigh))):
	print("q{}".format(i), "," ,end="")	
print("}")
'''
#print(group_list)
#print(len(list(G.nodes())))

#nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size = 10)
#nx.draw_networkx_edge_labels(G, pos=pos,font_size = 7, edge_labels=edge_weights_label, font_color='black')
#plt.show()
