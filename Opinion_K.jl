# Simulation code for plotting fixation time
include("Indirect_network.jl")
using Random

N = parse(Int, ARGS[1])
#leng = 1
leng = parse(Int, ARGS[2])

initial_prob = 0.5
#K_arr = [0.99]

K_arr = collect(range(start=0.75, stop = 0.758, length = 9))
K_append =  collect(range(start=0.759, stop=1, length=leng)) # p_idx = 1:leng, so prob = P1[p_idx]

for i in 1:leng
    push!(K_arr, K_append[i])
end

O_arr = zeros(length(K_arr))
prob = 1.0

for K_idx in 1:length(K_arr)
    K = K_arr[K_idx]
    e_matrix = zeros(N, N)
    σ_matrix = zeros(N, N)
    U_matrix = zeros(N, N) # Additional matrix for update by new method, 'New_matrix' of 'L6_rule_dr_all'.
    Edge_list = Any[]
    Triad_list = Any[]
    Opinion_Initialize(σ_matrix, initial_prob, N)
    number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
    
    num_edge = number_arr[1]
    num_triad = number_arr[2]
    #if n_idx == 1
    #    println(num_edge,"   ", num_triad)
    #end
    τ = 0
    τ_tmp = 0
    while true
        τ_tmp = K_update(K_rule, σ_matrix, e_matrix, N, τ, K)
        # For random sequential update, use the function below :
        #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, N, τ)
        τ = τ_tmp
        
        check_sum = 0
        N3_sum = 0
        for m in 1:N
            for n in 1:N
                for w in 1:N
                    if (e_matrix[m,n] == 1 && e_matrix[m,w] == 1 && e_matrix[n,w] == 1)
                        N3_sum += 1
                        if (σ_matrix[m,n] == K_result(σ_matrix, m, n, w, K))
                            check_sum += 1
                        end
                    end
                end
            end
        end
        
        if (N3_sum == check_sum)
            break
        end
    end
    #print(σ_matrix)
    #print("\n")
    #print("\n")
    O_arr[K_idx] = (1 - Opinions_average(σ_matrix, e_matrix, N))
end

for i in 1:length(K_arr)
    println(K_arr[i], "    ",O_arr[i])
end