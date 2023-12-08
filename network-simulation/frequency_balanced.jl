# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 3)
    print("usage : N_f n_realization ϵ \n")
    exit(1)
end
N_f = parse(Int64, ARGS[1])
N_arr = 4:N_f
n_run = parse(Int64, ARGS[2])
ϵ = parse(Float64, ARGS[3])

initial_prob = 0.5
#if (N==4) σ_arr = [-2,0,6] end

#result_arr = zeros(3)
for N in N_arr
    σ_arr = zeros(2)
    for n_idx in 1:n_run
        prob = 1.0 # for complete graph, p=1.0
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
            #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, Edge_list, τ)
            τ = τ_tmp

            #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
            if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
                val = Opinions_average(σ_matrix, e_matrix, N)
                if (val == 1.0) 
                    σ_arr[2] += 1
                else 
                    σ_arr[1] += 1
                end
                #for v_idx in 1:length(σ_arr)
                #    v = σ_arr[v_idx]
                #    if (val == v)
                #        result_arr[v_idx] += 1
                #    end
                #end
                break
            end
        end
    end
    σ_arr /= n_run
    println(N, "    ", σ_arr[2])
end

#result_arr /= n_run
#print(result_arr)