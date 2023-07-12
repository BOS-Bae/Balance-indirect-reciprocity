# Simulation code for plotting fixation time
include("Indirect_network.jl")
using Random

e_matrix = transpose([[0, 1, 0, 1, 0] [1, 0, 1, 1, 1] [0, 1, 0, 1, 1] [1, 1, 1, 0, 1] [0, 1, 1, 1, 0]])
σ_matrix = transpose([[0, 1, 0, 1, 0] [1, 0, -1, 1, 1] [0, -1, 0, 1, -1] [1, 1, 1, 0, -1] [0, 1, -1, -1, 0]])

N = length(e_matrix)
println("N=", N)
#U_matrix = zeros(N, N) # Additional matrix for update by new method, 'New_matrix' of 'L6_rule_dr_all'.

Edge_list = Any[]
Triad_list = Any[]

number_arr = Edge_Triad_list(e_matrix, N, Edge_list, Triad_list)

num_edge = number_arr[1]
num_triad = number_arr[2]

Phi_list = zeros(num_triad, 6)
Idx_list = zeros(num_triad, 6, 3)
#Head_list = Any[]

τ = 0
τ_tmp = 0
while true
    τ_tmp = Phi_update(σ_matrix, e_matrix, N, τ, num_triad, Triad_list, Phi_list, Idx_list)
    # For random sequential update, use the function below :
    #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, N, τ)
    τ = τ_tmp
    
    #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
    if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
        break
    end
end
τ_arr[p_idx] = τ


for i in 1:leng
    print(τ_arr[i], " ")
end
