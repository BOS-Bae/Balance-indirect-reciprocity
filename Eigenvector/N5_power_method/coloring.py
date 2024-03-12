import networkx as nx
import matplotlib.pyplot as plt

# Sample data: directed graph with weighted edges
edges = [('A', 'B', 3), ('A', 'C', 2), ('A', 'D', 4), ('B', 'C', 1), ('C', 'D', 3)]
# Creating a directed graph
G = nx.DiGraph()

# Adding edges with weights
for edge in edges:
    G.add_edge(edge[0], edge[1], weight=edge[2])

# Grouping nodes based on degree and weight
node_groups = {}
for node in G.nodes():
    degree = G.degree[node]
    weight_sum = sum([G.edges[node, neighbor]['weight'] for neighbor in G.neighbors(node)])
    group = (degree, weight_sum)
    if group not in node_groups:
        node_groups[group] = []
    node_groups[group].append(node)

# Assigning colors to node groups
color_map = {}
group_index = 1
for group_nodes in node_groups.values():
    for node in group_nodes:
        color_map[node] = group_index
    group_index += 1

# Drawing the graph
pos = nx.spring_layout(G)
nx.draw(G, pos, with_labels=True, node_color=[color_map[node] for node in G.nodes()], cmap=plt.cm.tab10)
edge_labels = nx.get_edge_attributes(G, 'weight')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

# Showing the plot
plt.show()

# Printing information about each group
for group_index, group_nodes in enumerate(node_groups.values(), start=1):
    print(f"Group {group_index}: Nodes {', '.join(group_nodes)}")

