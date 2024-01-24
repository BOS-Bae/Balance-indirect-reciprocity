# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 2)
    print("usage : N ϵ \n")
    exit(1)
end

N = parse(Int64, ARGS[1])
ϵ = parse(Float64, ARGS[2])

initial_prob = 0.5

prob = 1.0 # for complete graph

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

while (true)
    global τ, τ_tmp
    τ_tmp = original_update(L8_rule, σ_matrix, e_matrix, N, τ, ϵ)
    # For random sequential update, use the function below :
    #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, Edge_list, τ, ϵ)
    τ = τ_tmp
    
    #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
    if (Check_absorbing(σ_matrix, e_matrix, N, L8_rule_ab) == true)
        break
    end
end

for i in 1:N
    for j in 1:N
        print(σ_matrix[i,j], " ")
    end
    print("\n")
end