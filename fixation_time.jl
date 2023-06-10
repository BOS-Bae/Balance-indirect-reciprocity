# Simulation code for plotting fixation time
include("Indirect_network.jl")
using Random

N = parse(Int, ARGS[1])
leng = parse(Int, ARGS[2])

initial_prob = 0.5

P1 =  collect(range(start=0.1, stop=1.0, length=leng)) # p_idx = 1:leng, so prob = P1[p_idx]
τ_arr = zeros(leng)
    
for p_idx in 1:leng
    prob = P1[p_idx]
    
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
        τ_tmp = original_update(L6_rule, σ_matrix, e_matrix, N, τ)
        # For random sequential update, use the function below :
        #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, N, τ)
        τ = τ_tmp
        
        #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
        if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
            break
        end
    end
    τ_arr[p_idx] = τ
end


for i in 1:leng
    print(τ_arr[i], " ")
end