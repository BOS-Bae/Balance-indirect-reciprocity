# Simulation code for checking if formulae is correct or not.
include("Indirect_network.jl")
using Random

N = parse(Int, ARGS[1])
prob = parse(Float64, ARGS[2])
Max_time = parse(Int, ARGS[3])
n_sample = parse(Int, ARGS[4])

initial_prob = 0.5

n_result = zeros(3, Max_time)
f_result = zeros(3, Max_time)

for s in 1:n_sample
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
    n_arr = zeros(3)
    f_arr = zeros(3)

    tmp_arr = zeros(3)
    tmp_arr_τ = zeros(3)
    τ = 0
    τ_tmp = 0
    #prevent_div = 10000 # value for preventing divergence of variable
    
    for step in 1:Max_time
        d = rand(1:N)
        r = rand(1:N)
        tmp_arr = Balance(σ_matrix, e_matrix, N, Edge_list, Triad_list, num_edge, num_triad)

        f_arr = sum_formulae(σ_matrix, e_matrix, N, d, r)

        τ_tmp = d_r_pair_update(L6_rule, σ_matrix, e_matrix, N, τ, d, r)
        # For random sequential update, use the function below :
        #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, N, τ)
        τ = τ_tmp
    
        tmp_arr_τ = Balance(σ_matrix, e_matrix, N, Edge_list, Triad_list, num_edge, num_triad)
        n_arr = (tmp_arr_τ - tmp_arr)

        for i in 1:3
            n_result[i, step] += n_arr[i]
            f_result[i, step] += f_arr[i]
        end
    end
    #τ_arr[p_idx] = τ
end

n_result /= n_sample
f_result /= n_sample

for j in 1:Max_time
    for i in 1:3
        print(n_result[i,j], " ")
    end
    for i in 1:3
        print(f_result[i,j], " ")
    end
    print("\n")
end
