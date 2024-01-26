# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 3)
    print("usage : N_f n_sample ϵ \n")
    exit(1)
end
#N_0 = 3
N_0 = 3
N_f = parse(Int64, ARGS[1])
n_sample = parse(Int64, ARGS[2])
ϵ = parse(Float64, ARGS[3])

initial_prob = 0.5
leng = (N_f-N_0+1)
δ_arr = zeros(n_sample, leng)

for n_idx in 1:n_sample
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
            τ_tmp = original_update(L6_rule, σ_matrix, e_matrix, N, τ, ϵ)
            # For random sequential update, use the function below :
            #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, Edge_list, τ, ϵ)
            τ = τ_tmp
            
            #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
            if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
                break
            end
        end
        δ = cluster_diff_complete(σ_matrix, N)
        δ_arr[n_idx, N-N_0+1] = δ
    end
end

result_arr = zeros(leng)
std_arr = zeros(leng)
for i in 1:leng
    result_arr[i] = sum(δ_arr[:,i])
end
result_arr /= n_sample

for i in 1:leng
    val = 0
    for n in 1:n_sample
        val += (δ_arr[n, i] - result_arr[i])^2
    end
    std_val = sqrt(val)/sqrt(n_sample-1)
    std_arr[i] = std_val/sqrt(n_sample)
end

for N in N_0:N_f
    print(N, " ")
end
println("")

for i in 1:leng
    print(result_arr[i], " ")
end
println("")

for i in 1:leng
    print(std_arr[i], " ")
end
println("")
