# Code for counting the number of structure
include("Indirect_network.jl")
using Random

N = parse(Int, ARGS[1])
leng = parse(Int, ARGS[2])
n_sample = parse(Int, ARGS[3])
normalize = parse(Float64, ARGS[3])

P1 =  collect(range(start=0.1, stop=1.0, length=leng)) # p_idx = 1:leng, so prob = P1[p_idx]
n_result = zeros(leng, 3)

for s in 1:n_sample
    for p_idx in 1:leng
        prob = P1[p_idx]

        e_matrix = zeros(N, N)
        σ_matrix = zeros(N, N)

        Edge_list = Any[]
        Triad_list = Any[]

        number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
        T = Q = R = 0
        TQR_arr = count_structure(e_matrix, N)

        num_edge = number_arr[1]
        num_triad = number_arr[2]
        
        for i in 1:3
            n_result[p_idx,i] += TQR_arr[i]/normalize
        end
    end
end

for i in 1:leng
    for j in 1:3
        print(n_result[i,j], " ")
    end
    print("\n")
end