# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 2)
    print("usage : N_f ϵ \n")
    exit(1)
end
N_0 = 3
N_f = parse(Int64, ARGS[1])
ϵ = parse(Float64, ARGS[2])

initial_prob = 0.5
leng = (N_f-N_0+1)
#δ_arr = zeros(leng)

for N in N_0:N_f
    prob = 1
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
        τ_tmp = original_update(L4_rule, σ_matrix, e_matrix, N, τ, ϵ)
        # For random sequential update, use the function below :
        #τ_tmp = random_sequential_update(L4_rule, σ_matrix, e_matrix, Edge_list, τ, ϵ)
        τ = τ_tmp
        
        #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
        if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
            break
        end
    end
    δ = cluster_diff_complete(σ_matrix, N)
	print(N, "  ",δ,"\n")
end

