# Simulation code for plotting time-series data
include("../Indirect_network.jl")
using Random

N = 30
n_sample = 50
prob = 1.0

initial_prob = 0.5
τ_final = 40
#τ_final = 50000

val_2d_arr = zeros(n_sample, τ_final)
val_avg = zeros(τ_final)
val_std = zeros(τ_final)

for n_idx in 1:n_sample
    
    e_matrix = zeros(N, N)
    σ_matrix = zeros(N, N)
    
    Edge_list = Any[]
    Triad_list = Any[]
    Opinion_Initialize(σ_matrix, initial_prob, N)
    number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
    
    num_edge = number_arr[1]
    num_triad = number_arr[2]
    
    record_val = 0
    τ = 0
    while true
        #τ_tmp = original_update(L6_rule, σ_matrix, e_matrix, N, τ)
        # For random sequential update, use the function below :
        τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, N, τ)
        τ = τ_tmp
        
        record_val = Opinions_average(σ_matrix, e_matrix, N)
        val_2d_arr[n_idx, τ] = record_val
        if (τ == τ_final)
            break
        end
    end

end

# Get the average from data of n realizations
for i in 1:τ_final
    for j in 1:n_sample
        val_avg[i] += val_2d_arr[j,i]/n_sample
    end
end

for i in 1:τ_final
    Standard_err = 0
    for j in 1:n_sample
        Standard_err += (val_2d_arr[j,i] - val_avg[i])^2 / (n_sample - 1)
    end
    val_std[i] = sqrt(Standard_err / n_sample)
end

print(val_avg)
println("")
print(val_std)
