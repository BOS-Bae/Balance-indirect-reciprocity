# Simulation code with functions which are defined above.
include("Indirect_network.jl")
using Random

N = 30
n_sample = 20

initial_prob = 0.5
leng = 50

#τ_init_check = 5*N*N
#τ_length = 5*N*N

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
        
        if p_idx % 10 == 0
            print("p=", prob, "\n")
        end
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
        while true
            d = rand(1:N)
            r = rand(1:N)
            if (e_matrix[d,r] == 1)
                τ += 1
                NList = NeighborList(e_matrix,N,d,r)
                L6_rule(σ_matrix, NList, d, r)
            
                if (τ >= τ_init_check)
                    Im_val += Imbalance(σ_matrix, Triad_list, num_triad)
                end
                # imbalance should be calculated when (e_matrix[d,r] == 1), not otherwise.
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

print(Im_avg)
println("")
print(Im_std)