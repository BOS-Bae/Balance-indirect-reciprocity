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
balance_check = zeros(2, Max_time)

for s in 1:n_sample
    #print(s,"\n")
    e_matrix = zeros(N, N)
    σ_matrix = zeros(N, N)
    U_matrix = zeros(N, N) # Additional matrix for update by new method, 'New_matrix' of 'L6_rule_dr_all'.
    Edge_list = Any[]
    Triad_list = Any[]
    Opinion_Initialize(σ_matrix, initial_prob, N)
    number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
    
    num_edge = number_arr[1]
    num_triad = number_arr[2]
    
    f_arr = zeros(3)

    tmp_arr = zeros(3)
    tmp_arr_τ = zeros(3)
    tmp_edge = num_edge
    tmp_triad = num_triad
    
    for step in 1:Max_time
        d = rand(1:N)
        r = rand(1:N)
        tmp_arr = Balance(σ_matrix, e_matrix, N, Edge_list, Triad_list, num_edge, num_triad)

        f_arr = sum_formulae(σ_matrix, e_matrix, N, d, r)

        d_r_pair_update(L6_rule, σ_matrix, e_matrix, N, d, r)
        # For random sequential update, use the function below :
        #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, N, τ)
    
        tmp_arr_τ = Balance(σ_matrix, e_matrix, N, Edge_list, Triad_list, num_edge, num_triad)

        for i in 1:3
            n_result[i, step] += (tmp_arr_τ[i] - tmp_arr[i])
            f_result[i, step] += f_arr[i]
        end

        balance_check[1, step] += tmp_arr_τ[1]/tmp_edge
        balance_check[2, step] += tmp_arr_τ[2]/(6*tmp_triad)
    end
end

n_result /= n_sample
f_result /= n_sample
balance_check /= n_sample


for j in 1:Max_time
    for i in 1:3
        print(f_result[i,j], " ")
    end
    for i in 1:3
        print(n_result[i,j], " ")
    end
    for i in 1:2
        print(balance_check[i,j], " ")
    end
    print("\n")
end
