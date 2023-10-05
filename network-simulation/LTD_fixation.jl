# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 2)
    print("usage : N_max n_sample \n")
    print("!) N_max should be even number. \n")
    exit(1)
end

N_max = parse(Int64, ARGS[1])
n_sample = parse(Int64, ARGS[2])
p_LTD = 1/3

N_min = 4
N_leng = Int64((N_max - N_min)/2 + 1)
N_arr = range(N_min, stop=N_max, length=N_leng)

initial_prob = 0.5

τ_arr = zeros(n_sample,N_leng)
    
for n_idx in 1:n_sample
    prob = 1.0
    for N_idx in 1:N_leng
        N = Int64(N_arr[N_idx])
        println(N)

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
            τ_tmp = LTD_update(LTD_rule, σ_matrix, e_matrix, N, τ, p_LTD)
            τ = τ_tmp
            
            #if (Check_absorbing(σ_matrix, e_matrix, N, L6_rule_ab) == true)
            if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
                break
            end
        end
        τ_arr[n_idx, N_idx] = τ
    end
end

result_arr = zeros(N_leng)
std_arr = zeros(N_leng)
for i in 1:N_leng
    result_arr[i] = sum(τ_arr[:,i])
end
result_arr /= n_sample

for i in 1:N_leng
    val = 0
    for n in 1:n_sample
        val += (τ_arr[n, i] - result_arr[i])^2
    end
    std_val = sqrt(val)/sqrt(n_sample-1)
    std_arr[i] = std_val/sqrt(n_sample)
end

for i in 1:N_leng
    println(N_arr[i], "  " , result_arr[i], "  ", std_arr[i])
end
