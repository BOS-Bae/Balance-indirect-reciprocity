# Simulation code for calculating imbalance values for different connection probabilities.
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 4)
    print("usage : N p_leng n_sample ϵ \n")
    exit(1)
end

N = parse(Int64, ARGS[1])
leng = parse(Int64, ARGS[2])
n_sample = parse(Int64, ARGS[3])
ϵ = parse(Float64, ARGS[4])

initial_prob = 0.5

τ_init_check = 5*N*N
τ_length = 5*N*N

P1 =  collect(range(start=0.02, stop=1.0, length=leng)) # p_idx = 1:leng, so prob = P1[p_idx]
Im_2d_arr = zeros(n_sample, leng)
Im_avg = zeros(leng)
Im_std = zeros(leng)

for n_idx in 1:n_sample
    print("n=", n_idx, "\n")
    
    for p_idx in 1:leng
        prob = P1[p_idx]
        print("p=", prob, "\n")
        e_matrix = zeros(N, N)
        σ_matrix = zeros(N, N)
        
        Edge_list = Any[]
        Triad_list = Any[]

        Opinion_Initialize(σ_matrix, initial_prob, N)
        number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
        
        num_edge = number_arr[1]
        num_triad = number_arr[2]
        
        Im_val = 0
        τ = 0
        while (true)
            τ_tmp = original_update(L6_rule, σ_matrix, e_matrix, N, τ, ϵ)
            # For random sequential update, use the function below :
            #τ_tmp = random_sequential_update(L6_rule, σ_matrix, e_matrix, Edge_list, τ, ϵ)
            τ = τ_tmp
            
            if (τ >= τ_init_check)
                Im_val += Imbalance(σ_matrix, Triad_list, num_triad)
            end
            
            if (τ == (τ_init_check + τ_length))
                break
            end
        end

        Im_2d_arr[n_idx, p_idx] = (Im_val/ (τ_length + 1) )
    end
end

# Get the average from data of n realizations
for i in 1:leng
    for j in 1:n_sample
        Im_avg[i] += Im_2d_arr[j,i]/n_sample
    end
end

for i in 1:leng
    Standard_err = 0
    for j in 1:n_sample
        Standard_err += (Im_2d_arr[j,i] - Im_avg[i])^2 / (n_sample - 1)
    end
    Im_std[i] = sqrt(Standard_err / n_sample)
end

for i in 1:leng
    println(Im_avg[i], "  ", Im_std[i])
end