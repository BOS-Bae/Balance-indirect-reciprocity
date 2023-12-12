# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 2)
    print("usage : ϵ n_run \n")
    exit(1)
end
#N_f = parse(Int64, ARGS[1])
#N_arr = 4:N_f
N=4
ϵ = parse(Float64, ARGS[1])
n_run = parse(Int64, ARGS[2])

initial_prob = 0.5

balanced_list = []
push!(balanced_list, [[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1]])
push!(balanced_list, [[1,-1,-1,-1],[-1,1,1,1],[-1,1,1,1],[-1,1,1,1]])
push!(balanced_list, [[1,-1,1,1],[-1,1,-1,-1],[1,-1,1,1],[1,-1,1,1]])
push!(balanced_list, [[1,1,-1,1],[1,1,-1,1],[-1,-1,1,-1],[1,1,-1,1]])
push!(balanced_list, [[1,1,1,-1],[1,1,1,-1],[1,1,1,-1],[-1,-1,-1,1]])
push!(balanced_list, [[1,1,-1,-1],[1,1,-1,-1],[-1,-1,1,1],[-1,-1,1,1]])
push!(balanced_list, [[1,-1,1,-1],[-1,1,-1,1],[1,-1,1,-1],[-1,1,-1,1]])
push!(balanced_list, [[1,-1,-1,1],[-1,1,1,-1],[-1,1,1,-1],[1,-1,-1,1]])
#if (N==4) σ_distri = [-2,0,6] end

σ_distri = zeros(n_run, 8)
result_arr = zeros(8)

#if n_idx == 1
#    println(num_edge,"   ", num_triad)
#end
for n_idx in 1:n_run
    τ = 0
    τ_tmp = 0
    t = 0 
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
    while(true)
        #τ_tmp = original_update(L4_rule, σ_matrix, e_matrix, N, τ, ϵ)
        τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, Edge_list, τ, ϵ)
        # For random sequential update, use the function below :
        #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, Edge_list, τ)
        τ = τ_tmp
        if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
            for b in 1:8
                count = 0
                check = 0
                for x in 1:N
                    for y in 1:N
                        count += 1
                        if (balanced_list[b][x][y] == σ_matrix[x,y])
                            check += 1
                        end
                    end
                end
                if (check == count)
                    σ_distri[n_idx, b] = 1
                end
            end
            break
        end
    end
end

for b in 1:8
    result_arr[b] = sum(σ_distri[:,b])
end

result_arr /= n_run
for b in 1:8
    println(result_arr[b])
    #println(N," ", σ_distri[b])
end
println("sum : ", sum(result_arr))